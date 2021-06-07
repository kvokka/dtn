# frozen_string_literal: true

require "yaml"
require "fileutils"

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

      cassette_filename = spec.full_description.sub(/^Dtn::/, "").underscore.gsub(" ", "_")
      cassette_filename += "_#{SecureRandom.alphanumeric(10)}" if spec.description.empty?
      cassette_filename += ".yaml"

      @filename = Pathname.new(CASSETTES_PATH).join(cassette_filename)
    end

    private

    attr_writer :reads, :writes
    attr_reader :spec

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
    super unless @cassette.persisted?
  end

  attr_reader :cassette

  %i[read getc gets read_nonblock].each do |method|
    define_method(method) do |*args, **opts|
      return (super(*args, **opts).tap { |r| cassette.reads << r }) unless cassette.persisted?

      raise("Trying to read more than was saved in the cassette #{casette.filename}") if cassette.reads.empty?

      cassette.reads.shift
    end
  end

  %i[write write_nonblock].each do |method|
    define_method(method) do |line, *args, **opts|
      if cassette.persisted?
        raise("Trying to write more than was saved in the cassette #{casette.filename}") if cassette.writes.empty?

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
