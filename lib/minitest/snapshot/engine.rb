require "importmap-rails"

module Minitest
  module Snapshot
    class Engine < ::Rails::Engine
      isolate_namespace Minitest::Snapshot

      rake_tasks do
        load "tasks/tmp.rake"
      end

      initializer "minitest_snapshot.importmap", before: "importmap" do |app|
        app.config.importmap.paths << root.join("config/importmap.rb")
        app.config.importmap.cache_sweepers << root.join("app/assets/javascripts")
      end

      initializer "minitest_snapshot.assets.precompile" do |app|
        app.config.assets.precompile += %w[minitest/snapshot/manifest]
      end

      initializer "minitest_snapshot.include_test_integration_helpers" do |_app|
        ActiveSupport.on_load(:action_dispatch_integration_test) do
          include Minitest::Snapshot::Test::IntegrationHelpers
        end
      end

      config.after_initialize do |app|
        app.routes.prepend do
          mount Minitest::Snapshot::Engine, at: "/rails/snapshots"
        end
      end
    end
  end
end
