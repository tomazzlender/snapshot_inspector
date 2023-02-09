require "minitest/snapshot"
require "minitest/snapshot/cleaner"

module Minitest
  class SnapshotReporter < Reporter
    def report
      io.print "\n\nInspect snapshots on #{Minitest::Snapshot.configuration.host + Minitest::Snapshot.configuration.route_path}"
    end
  end

  class << self
    def plugin_snapshot_options(opts, _options)
      opts.on "--take-snapshots", "Take snapshots of responses for inspecting at #{Minitest::Snapshot.configuration.host + Minitest::Snapshot.configuration.route_path}" do
        Minitest::Snapshot.configuration.snapshot_taking_enabled = true
      end
    end

    def plugin_snapshot_init(_options)
      return unless Minitest::Snapshot.configuration.snapshot_taking_enabled

      reporter << SnapshotReporter.new
      Minitest::Snapshot::Cleaner.clean_snapshots_from_previous_run
    end
  end
end
