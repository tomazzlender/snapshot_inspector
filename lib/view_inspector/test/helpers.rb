module ViewInspector
  module Test
    module Helpers
      extend ActiveSupport::Concern

      # Takes a snapshot of the given response.
      #
      # +take_snapshot+ can be called after the +response+ object becomes available
      # for inspection in the lifecycle of the integration test. You can take one or
      # more snapshots in a single test case.
      #
      # Snapshots are taken only when explicitly enabled with a flag --take-snapshots.
      # E.g. bin/rails test --take-snapshots
      def take_snapshot(snapshotee)
        return unless ViewInspector.configuration.snapshot_taking_enabled

        increment_take_snapshot_counter_scoped_by_test

        ViewInspector::Snapshot.persist(
          snapshotee: snapshotee,
          context: {
            method_name: method_name,
            source_location: method(method_name).source_location,
            test_case_name: self.class.to_s,
            take_snapshot_index: _take_snapshot_counter - 1
          }
        )
      end

      private

      attr_reader :_take_snapshot_counter

      def increment_take_snapshot_counter_scoped_by_test
        @_take_snapshot_counter ||= 0
        @_take_snapshot_counter += 1
      end
    end
  end
end
