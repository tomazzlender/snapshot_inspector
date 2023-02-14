module ViewInspector
  class Snapshot
    class NotFound < StandardError; end

    class InvalidInput < StandardError; end

    attr_reader :slug, :snapshotee_recording_klass, :response_recording, :test_recording, :created_at

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
      @response_recording = ResponseRecording.parse(snapshotee)
      @test_recording = TestRecording.parse(test)
      @created_at = Time.current
      @slug = to_slug
      @snapshotee_recording_klass = snapshotee_recording_klass_mapping(snapshotee).to_s
      self
    end

    def persist
      Storage.write(slug, JSON.pretty_generate(as_json))
      self
    end

    def from_json(json)
      @created_at = Time.zone.parse(json[:created_at])
      @slug = json[:slug]
      @response_recording = ResponseRecording.new.from_json(json[:response_recording])
      @test_recording = TestRecording.new.from_json(json[:test_recording])
      @snapshotee_recording_klass = json[:snapshotee_recording_klass]
      self
    end

    def to_slug
      [test_recording.test_case_name.underscore, "#{test_recording.method_name}_#{test_recording.take_snapshot_index}"].join("/")
    end

    def snapshotee_recording_klass_mapping(snapshotee)
      case snapshotee.class.to_s
      when "ActionDispatch::TestResponse" then ResponseRecording
      else
        raise InvalidInput
      end
    end
  end
end
