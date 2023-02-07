module Minitest
  module Snapshot
    class Snapshot
      def self.all
        source_directory = Rails.root.join("tmp/snapshots")
        test_case_files = Dir.glob("#{source_directory}/**/*.{json}")

        test_case_files
          .map { |test_case_file| JSON.parse(File.read(test_case_file), symbolize_names: true) }
          .flatten
          .sort_by { |snapshot| snapshot[:created_at] }
          .reverse
      end
    end
  end
end
