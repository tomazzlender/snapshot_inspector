module ViewInspector
  class Snapshot
    class NotFound < StandardError; end

    class InvalidInput < StandardError; end

    attr_reader :slug, :response_recording, :test_recording, :created_at

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
      self
    end

    def to_slug
      [test_recording.test_case_name.underscore, "#{test_recording.method_name}_#{test_recording.take_snapshot_index}"].join("/")
    end

    class ResponseRecording
      attr_reader :body

      def self.parse(response)
        new.parse(response)
      end

      def parse(response)
        @body = response.parsed_body
        self
      end

      def from_json(json)
        @body = json[:body]
        self
      end
    end

    class TestRecording
      # Name `:take_snapshot_index` could be improve. It represents: if two snapshots are taken in a single test, they will have indexes 0 and 1.
      attr_reader :name, :method_name, :source_location, :test_case_name, :take_snapshot_index, :test_case_file_path, :line_number

      def self.parse(test_recording)
        new.parse(test_recording)
      end

      def parse(test)
        @name = test[:method_name].gsub(/^test_/, "").humanize(capitalize: false)
        @method_name = test[:method_name]
        @source_location = test[:source_location]
        @test_case_name = test[:test_case_name]
        @take_snapshot_index = test[:take_snapshot_index]
        @test_case_file_path = source_location.first
        @line_number = source_location.last
        self
      end

      def from_json(json)
        @name = json[:name]
        @method_name = json[:method_name]
        @source_location = json[:source_location]
        @test_case_name = json[:test_case_name]
        @take_snapshot_index = json[:take_snapshot_index]
        @test_case_file_path = json[:test_case_file_path]
        @line_number = json[:line_number]
        self
      end
    end
  end
end
