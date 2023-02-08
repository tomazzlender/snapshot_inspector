module Minitest
  module Snapshot
    class Snapshot
      class << self
        def all
          test_case_files = Dir.glob("#{Minitest::Snapshot.configuration.storage_directory}/**/*.{json}")

          snapshots =
            test_case_files
              .map { |test_case_file| JSON.parse(File.read(test_case_file), symbolize_names: true) }
              .flatten

          order_by_line_number(snapshots)
        end

        def grouped_by_test_class
          all.group_by do |snapshot|
            snapshot[:test_class]
          end
        end

        def find(slug)
          file_path = slug.split("/")[0..-2].join("/")
          absolute_file_path = Minitest::Snapshot.configuration.storage_directory.join("#{file_path}.json")
          snapshots = JSON.parse(File.read(absolute_file_path), symbolize_names: true)

          snapshots.find { |snapshot| snapshot[:slug] == slug }
        end

        private

        def order_by_line_number(snapshots)
          snapshots.sort_by do |snapshot|
            snapshot[:source_location].dup << snapshot[:slug]
          end
        end
      end
    end
  end
end
