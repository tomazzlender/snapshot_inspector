module Minitest
  module Snapshot
    module Test
      module IntegrationHelpers
        extend ActiveSupport::Concern

        Rails.root.join("tmp", "snapshots").rmtree

        # Takes a snapshot of the given response.
        #
        # +take_snapshot+ can be called after the +response+ object becomes available
        # for inspection in the lifecycle of the integration test. You can take one or
        # more snapshots in a single test case.
        #
        # The method implementation is a work in progress.
        def take_snapshot(response)
          increment_test_case_snapshot_counter

          file_path = get_file_path_or_create_file_for_storage
          contents = parse_contents(file_path)

          new_contents = contents << new_snapshot(response)

          file_path.write(format_content_for_storage(new_contents))
        end

        private

        attr_accessor :_snapshot_counter

        def increment_test_case_snapshot_counter
          @_snapshot_counter ||= 0
          @_snapshot_counter += 1
        end

        def format_content_for_storage(contents)
          JSON.pretty_generate(contents)
        end

        def parse_contents(file_path)
          file_content = File.read(file_path)
          JSON.parse(file_content)
        end

        def get_file_path_or_create_file_for_storage
          absolute_file_path.dirname.mkpath

          unless File.exist?(absolute_file_path)
            default_json_contents = [].to_json
            absolute_file_path.write(default_json_contents)
          end

          absolute_file_path
        end

        def new_snapshot(response)
          {
            slug: "#{test_class_name.underscore}/#{test_case_name}/#{index}",
            created_at: Time.current,
            response_body: response.parsed_body,
            test_case_name: test_case_name,
            test_case_human_name: test_case_name.gsub(/^test_/, "").humanize,
            test_class: test_class_name
          }
        end

        def absolute_file_path
          Rails.root.join(tmp_snapshot_directory_path, test_class_name.underscore, file_name)
        end

        def tmp_snapshot_directory_path
          "tmp/snapshots"
        end

        def file_name
          "#{test_case_name}.json"
        end

        def test_case_name
          method_name
        end

        def index
          _snapshot_counter - 1
        end

        def test_class_name
          self.class.to_s
        end
      end
    end
  end
end
