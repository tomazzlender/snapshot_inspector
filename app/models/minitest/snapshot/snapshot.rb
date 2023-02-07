module Minitest
  module Snapshot
    class Snapshot
      class << self
        def all
          source_directory = Rails.root.join("tmp/snapshots")
          test_case_files = Dir.glob("#{source_directory}/**/*.{json}")

          test_case_files
            .map { |test_case_file| JSON.parse(File.read(test_case_file), symbolize_names: true) }
            .flatten
            .sort_by { |snapshot| snapshot[:created_at] }
            .reverse
        end

        def grouped_by_test_class
          all.group_by do |snapshot|
            snapshot[:test_class]
          end
        end

        def find(slug)
          file_path = slug.split("/")[0..-2].join("/")
          absolute_file_path = Rails.root.join("tmp/snapshots/#{file_path}.json")
          snapshots = JSON.parse(File.read(absolute_file_path), symbolize_names: true)

          snapshots.find { |snapshot| snapshot[:slug] == slug }
        end
      end
    end
  end
end
