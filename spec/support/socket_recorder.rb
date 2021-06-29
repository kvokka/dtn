# frozen_string_literal: true

require "yaml"
require "fileutils"

# Add the ability to record the output from socket to file and read it
# from there afterwards
#
# For usage you can simple add `socket_recorder: true` to your spec or
# spec context. This will generate the separate file for each spec.
#
# If you want to share one socket request between a few specs, you can
# add a custom name `socket_recorder: 'my awesome file'`
#
# `infinite_reads: true` spec option allow to let it hang forever after
# the reads were drained, simulating IOWait. This allows to test streaming
# data
module TCPSocketWithRecorder
  class Cassette
    CASSETTES_PATH = "spec/fixtures"

    def initialize(spec)
      @spec = spec
      yaml_load if persisted?
    end

    def persisted?
      @persisted ||= File.exist?(filename)
    end

    def reads
      @reads ||= []
    end

    def infinite_reads?
      !!spec.metadata[:infinite_reads]
    end

    def writes
      @writes ||= []
    end

    def save
      return if persisted?

      verify_cassette_path_is_writable
      File.write(filename, yaml_dump)
    rescue Encoding::UndefinedConversionError
      File.binwrite(filename, yaml_dump)
    end

    def filename
      return @filename if @filename

      cassette_filename =
        if spec.metadata[:socket_recorder] == true
          calculate_filename
        else
          spec.metadata[:socket_recorder].underscore.gsub(" ", "_")
        end

      @filename = Pathname.new(CASSETTES_PATH).join("#{cassette_filename}.yaml")
    end

    private

    attr_writer :reads, :writes
    attr_reader :spec

    def calculate_filename
      fn = spec.full_description.sub(/^Dtn::/, "").underscore.gsub(" ", "_")
      fn += "_#{SecureRandom.alphanumeric(10)}" if spec.description.empty?
      fn
    end

    def yaml_dump
      YAML.dump(writes: writes, reads: reads)
    end

    def yaml_load
      YAML.safe_load(File.read(filename), [Symbol]).tap do |yaml|
        self.writes = yaml[:writes] if yaml[:writes].any?
        self.reads = yaml[:reads] if yaml[:reads].any?
      end
      true
    end

    def verify_cassette_path_is_writable
      FileUtils.mkdir_p(File.dirname(filename))
      FileUtils.touch(filename)
    end
  end

  def initialize(*_args)
    @cassette = Thread.current[:current_spec_cassette]
    super unless @cassette&.persisted?
  end

  attr_reader :cassette

  class ReadFromCassetteError < StandardError
    def initialize(casette:, line:)
      @casette = casette
      super
    end

    def message
      "Trying to read more than was saved in the cassette #{cassette.filename}"
    end
  end

  %i[read getc gets read_nonblock].each do |method|
    define_method(method) do |*args, **opts|
      return super(*args, **opts) unless cassette
      return (super(*args, **opts).tap { |r| cassette.reads << r }) unless cassette.persisted?
      return cassette.reads.shift unless cassette.reads.empty?

      sleep if cassette.infinite_reads?
      raise ReadFromCassetteError.new(casette: casette)
    end
  end

  class WriteToCassetteError < StandardError
    def initialize(casette:, line:)
      @casette = casette
      @line = line
      super
    end

    def message
      "Trying to write:\n\n    #{line.chomp}\n\n"\
      "It's more than was saved in the cassette #{cassette.filename}"
    end
  end

  %i[write write_nonblock].each do |method|
    define_method(method) do |line, *args, **opts|
      return super(line, *args, **opts) unless cassette

      if cassette.persisted?
        raise WriteToCassetteError.new(line: line, casette: casette) if cassette.writes.empty?

        cassette.writes.shift.length
      else
        cassette.writes << line
        super(line, *args, **opts)
      end
    end
  end
end

TCPSocket.prepend TCPSocketWithRecorder

RSpec.configure do |config|
  config.around(:each, socket_recorder: true) do |spec|
    Thread.current[:current_spec_cassette] = TCPSocketWithRecorder::Cassette.new(spec)
    spec.run
    Thread.current[:current_spec_cassette].save unless spec.exception
  ensure
    Thread.current[:current_spec_cassette] = nil
  end
end
