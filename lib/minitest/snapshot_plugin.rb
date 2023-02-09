require "minitest/snapshot"
require "minitest/snapshot/cleaner"

module Minitest
  class << self
    def plugin_snapshot_options(opts, _options)
      opts.on "--take-snapshots", "Take snapshots of responses for inspecting at http://localhost:3000/rails/snapshots" do
        Minitest::Snapshot.configuration.snapshot_taking_enabled = true
      end
    end

    def plugin_snapshot_init(_options)
      Minitest::Snapshot::Cleaner.clean_snapshots_from_previous_run if Minitest::Snapshot.configuration.snapshot_taking_enabled
    end
  end
end
