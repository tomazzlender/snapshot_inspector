require "view_inspector"
require "view_inspector/cleaner"
require "minitest"

module Minitest
  class ViewInspectorReporter < Reporter
    def report
      io.print "\n\nInspect snapshots on #{ViewInspector.configuration.host + ViewInspector.configuration.route_path}"
    end
  end

  class << self
    def plugin_view_inspector_options(opts, _options)
      opts.on "--take-snapshots", "Take snapshots of responses for inspecting at #{ViewInspector.configuration.host + ViewInspector.configuration.route_path}" do
        ViewInspector.configuration.snapshot_taking_enabled = true
      end
    end

    def plugin_view_inspector_init(_options)
      return unless ViewInspector.configuration.snapshot_taking_enabled

      reporter << ViewInspectorReporter.new
      ViewInspector::Cleaner.clean_snapshots_from_previous_run
    end
  end
end
