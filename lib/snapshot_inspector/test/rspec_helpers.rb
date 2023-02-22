module SnapshotInspector
  module Test
    module RSpecHelpers
      extend ActiveSupport::Concern

      # Takes a snapshot of the given +snapshotee+ (e.g. response or mail message).
      #
      # +take_snapshot+ can be called after the +snapshotee+ object becomes available
      # for inspection in the lifecycle of the spec (e.g. request or mailer spec). You can take one or
      # more snapshots in a single spec.
      #
      # Snapshots are taken only when explicitly enabled with an environment variable TAKE_SNAPSHOTS=1.
      # E.g. bin/rspec TAKE_SNAPSHOTS=1
      def take_snapshot(snapshotee)
        return unless SnapshotInspector.configuration.snapshot_taking_enabled

        increment_take_snapshot_counter_scoped_by_test

        SnapshotInspector::Snapshot.persist(
          snapshotee: snapshotee,
          context: {
            test_framework: :rspec,
            example: RSpec.current_example.metadata.except(:execution_result).as_json.with_indifferent_access,
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
