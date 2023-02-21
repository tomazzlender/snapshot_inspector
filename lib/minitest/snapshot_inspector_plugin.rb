require "snapshot_inspector"
require "snapshot_inspector/storage"
require "minitest"

module Minitest
  class SnapshotInspectorReporter < Reporter
    def report
      SnapshotInspector::Storage.move_files_from_processing_directory_to_snapshots_directory if SnapshotInspector::Storage.processing_directory.exist?

      io.print "\n\nInspect snapshots on #{SnapshotInspector.configuration.host + SnapshotInspector.configuration.route_path}"
    end
  end

  class << self
    def plugin_snapshot_inspector_options(opts, _options)
      opts.on "--take-snapshots", "Take snapshots of responses for inspecting at #{SnapshotInspector.configuration.host + SnapshotInspector.configuration.route_path}" do
        SnapshotInspector.configuration.snapshot_taking_enabled = true
      end
    end

    def plugin_snapshot_inspector_init(_options)
      return unless SnapshotInspector.configuration.snapshot_taking_enabled

      reporter << SnapshotInspectorReporter.new
      SnapshotInspector::Storage.clear(:processing)
    end
  end
end
