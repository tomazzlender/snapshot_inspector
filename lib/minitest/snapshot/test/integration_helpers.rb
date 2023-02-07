module Minitest
  module Snapshot
    module Test
      module IntegrationHelpers
        extend ActiveSupport::Concern

        # Takes a snapshot of the given response.
        #
        # +take_snapshot+ can be called after the +response+ object becomes available
        # for inspection in the lifecycle of the integration test. You can take one or
        # more snapshots in a single test case.
        #
        # The method implementation is a work in progress.
        def take_snapshot(response)
          test_case_name = method_name
          test_class_name = self.class.to_s

          file_path = Rails.root.join("tmp", "snapshots", test_class_name.underscore, "#{method_name}.json")
          file_path.dirname.mkpath
          file_path.write([].to_json) unless File.exist?(file_path)

          file_content = File.read(file_path)
          file_json = JSON.parse(file_content)

          snapshot = {
            created_at: Time.current,
            response_body: response.body,
            test_case_name: test_case_name,
            test_case_human_name: test_case_name.gsub(/^test_/, "").humanize,
            test_class: test_class_name
          }

          file_json << snapshot

          file_path.write(JSON.pretty_generate(file_json))
        end
      end
    end
  end
end
