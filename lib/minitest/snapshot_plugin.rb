module Minitest
  class << self
    def plugin_snapshot_options(opts, _options)
      opts.on "--with-snapshots", "Take snapshots of responses for inspecting at http://localhost:3000/rails/snapshots" do
        ENV["TAKE_SNAPSHOTS"] = "true"
      end
    end

    def plugin_snapshot_init(_options)
      purge_previous_snapshots if ENV["TAKE_SNAPSHOTS"] == "true"
    end

    private

    def purge_previous_snapshots
      Rails.root.join("tmp", "snapshots").rmtree
    end
  end
end
