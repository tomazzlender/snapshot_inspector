module Minitest
  module Snapshot
    class Engine < ::Rails::Engine
      isolate_namespace Minitest::Snapshot

      config.after_initialize do |app|
        app.routes.prepend do
          mount Minitest::Snapshot::Engine, at: "/rails/snapshots" if Rails.env.development?
        end
      end
    end
  end
end
