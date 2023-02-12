module ViewInspector
  class Snapshot
    class NotFound < StandardError; end

    attr_reader :slug, :response_recording, :test_recording, :created_at

    def self.persist(response:, test:)
      new.parse(response: response, test: test).persist
    end

    def self.find(slug)
      json = JSON.parse(File.read(Helpers.absolute_snapshot_file_path(slug)), symbolize_names: true)
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
      file_paths = Helpers.persisted_snapshots_file_paths(ViewInspector.configuration.absolute_storage_directory)

      snapshots = file_paths.map do |file_path|
        slug = Helpers.extract_slug(file_path)
        find(slug)
      end

      order_by_line_number(snapshots)
    end

    private_class_method def self.order_by_line_number(snapshots)
      snapshots.sort_by do |snapshot|
        snapshot.test_recording.source_location.dup << snapshot.test_recording.take_snapshot_index
      end
    end

    def parse(response:, test:)
      @response_recording = ResponseRecording.parse(response)
      @test_recording = TestRecording.parse(test)
      @created_at = Time.current
      @slug = Helpers.generate_slug(test_recording)
      self
    end

    def persist
      absolute_file_path = Helpers.absolute_snapshot_file_path(slug)
      absolute_file_path.dirname.mkpath
      absolute_file_path.write(JSON.pretty_generate(as_json))
      self
    end

    def from_json(json)
      @created_at = Time.zone.parse(json[:created_at])
      @slug = json[:slug]
      @response_recording = ResponseRecording.new.from_json(json[:response_recording])
      @test_recording = TestRecording.new.from_json(json[:test_recording])
      self
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

    module Helpers
      def self.absolute_snapshot_file_path(slug)
        ViewInspector.configuration.absolute_storage_directory.join("#{slug}.json")
      end

      def self.generate_slug(test_recording)
        [test_recording.test_case_name.underscore, "#{test_recording.method_name}_#{test_recording.take_snapshot_index}"].join("/")
      end

      def self.extract_slug(file_path)
        file_path.gsub(ViewInspector.configuration.absolute_storage_directory.to_s + "/", "").gsub(".json", "")
      end

      def self.persisted_snapshots_file_paths(storage_directory)
        Dir.glob("#{storage_directory}/**/*.{json}")
      end
    end
  end
end
