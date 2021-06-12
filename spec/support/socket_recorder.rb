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
      YAML.dump(reads: reads, writes: writes)
    end

    def yaml_load
      YAML.safe_load(File.read(filename), [Symbol]).tap do |yaml|
        self.reads = yaml[:reads] if yaml[:reads].any?
        self.writes = yaml[:writes] if yaml[:writes].any?
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

  %i[read getc gets read_nonblock].each do |method|
    define_method(method) do |*args, **opts|
      return super unless cassette
      return (super(*args, **opts).tap { |r| cassette.reads << r }) unless cassette.persisted?

      raise("Trying to read more than was saved in the cassette #{cassette.filename}") if cassette.reads.empty?

      sleep(0.001) until _reads_available

      cassette.reads.shift
    end
  end

  %i[write write_nonblock].each do |method|
    define_method(method) do |line, *args, **opts|
      return super unless cassette

      if cassette.persisted?
        raise("Trying to write more than was saved in the cassette #{casette.filename}") if cassette.writes.empty?

        # unlock reads only after the first non-system request
        cassette.writes.shift.tap { |inner_line| self._reads_available = true unless /^S,.+/ =~ inner_line }.length
      else
        cassette.writes << line
        super(line, *args, **opts)
      end
    end
  end

  private

  attr_accessor :_reads_available
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
