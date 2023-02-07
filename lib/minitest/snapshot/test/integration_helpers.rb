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
        def take_snapshot(_response)
          puts "Taken snapshot: #{self.class.to_s.underscore}/#{method_name}"
        end
      end
    end
  end
end
