require "importmap-rails"

module Minitest
  module Snapshot
    class Engine < ::Rails::Engine
      isolate_namespace Minitest::Snapshot

      initializer "minitest_snapshot.set_storage_directory" do |_app|
        Minitest::Snapshot.configuration.storage_directory = Rails.root.join("tmp", "snapshots")
      end

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

      initializer "minitest_snapshot.configure_default_url_options" do |_app|
        url_options =
          if Rails.application.routes.default_url_options.present?
            Rails.application.routes.default_url_options
          elsif Rails.application.config.action_controller.default_url_options.present?
            Rails.application.config.action_controller.default_url_options
          end

        Minitest::Snapshot.configuration.host = url_options ? [url_options[:host], url_options[:port]].join(":") : Minitest::Snapshot.configuration.host
      end

      config.after_initialize do |app|
        app.routes.prepend do
          mount Minitest::Snapshot::Engine, at: Minitest::Snapshot.configuration.route_path
        end
      end
    end
  end
end
