module ViewInspector
  class Snapshot
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
