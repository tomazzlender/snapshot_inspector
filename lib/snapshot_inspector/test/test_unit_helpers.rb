module SnapshotInspector
  module Test
    module Helpers
      extend ActiveSupport::Concern

      # Takes a snapshot of the given +snapshotee+ (e.g. response or mail message).
      #
      # +take_snapshot+ can be called after the +snapshotee+ object becomes available
      # for inspection in the lifecycle of the test (e.g. integration or mailer test). You can take one or
      # more snapshots in a single test case.
      #
      # Snapshots are taken only when explicitly enabled with a flag --take-snapshots
      # or when an environment variable TAKE_SNAPSHOTS=1 is set.
      # E.g. bin/rails test --take-snapshots
      def take_snapshot(snapshotee)
        return unless SnapshotInspector.configuration.snapshot_taking_enabled

        increment_take_snapshot_counter_scoped_by_test

        SnapshotInspector::Snapshot.persist(
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
