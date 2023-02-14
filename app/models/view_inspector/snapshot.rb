module ViewInspector
  class Snapshot
    class NotFound < StandardError; end

    class InvalidInput < StandardError; end

    attr_reader :test_recording, :slug, :created_at, :snapshotee_recording_klass, :response_recording

    def self.persist(snapshotee:, test:)
      raise InvalidInput.new(invalid_input_message(snapshotee)) unless snapshotee.is_a?(ActionDispatch::TestResponse)

      new.parse(snapshotee: snapshotee, test: test).persist
    end

    def self.find(slug)
      json = JSON.parse(Storage.read(slug), symbolize_names: true)
      new.from_json(json)
    rescue Errno::ENOENT
      raise NotFound.new("Snapshot with a slug `#{slug}` can't be found.")
    end

    def self.grouped_by_test_case
      all.group_by do |snapshot|
        snapshot.test_recording.test_case_name
      end
    end

    private_class_method def self.all
      snapshots = Storage.list.map { |slug| find(slug) }

      order_by_line_number(snapshots)
    end

    private_class_method def self.order_by_line_number(snapshots)
      snapshots.sort_by do |snapshot|
        snapshot.test_recording.source_location.dup << snapshot.test_recording.take_snapshot_index
      end
    end

    private_class_method def self.invalid_input_message(response)
      "#take_snapshot only accepts an argument of kind `ActionDispatch::TestResponse`. You provided `#{response.class}`."
    end

    def parse(snapshotee:, test:)
      @test_recording = TestRecording.parse(test)
      @slug = to_slug
      @created_at = Time.current
      @snapshotee_recording_klass = snapshotee_recording_klass_mapping(snapshotee)
      @response_recording = @snapshotee_recording_klass.parse(snapshotee)
      self
    end

    def persist
      Storage.write(slug, JSON.pretty_generate(as_json))
      self
    end

    def from_json(json)
      @test_recording = TestRecording.new.from_json(json[:test_recording])
      @slug = json[:slug]
      @created_at = Time.zone.parse(json[:created_at])
      @snapshotee_recording_klass = json[:snapshotee_recording_klass].constantize
      @response_recording = @snapshotee_recording_klass.new.from_json(json[:response_recording])
      self
    end

    def to_slug
      [test_recording.test_case_name.underscore, "#{test_recording.method_name}_#{test_recording.take_snapshot_index}"].join("/")
    end

    private

    def snapshotee_recording_klass_mapping(snapshotee)
      case snapshotee.class.to_s
      when "ActionDispatch::TestResponse" then ResponseRecording
      else
        raise InvalidInput
      end
    end
  end
end
