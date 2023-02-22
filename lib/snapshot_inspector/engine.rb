require "importmap-rails"
require "snapshot_inspector/test/action_mailer_headers"

module SnapshotInspector
  class Engine < ::Rails::Engine
    isolate_namespace SnapshotInspector

    config.before_configuration do |_app|
      SnapshotInspector.configuration.storage_directory = Rails.root.join(SnapshotInspector::STORAGE_DIRECTORY)
    end

    unless Rails.env.test?
      rake_tasks do
        load "tasks/tmp.rake"
      end
    end

    initializer "snapshot_inspector.importmap", before: "importmap" do |app|
      app.config.importmap.paths << root.join("config/importmap.rb")
      app.config.importmap.cache_sweepers << root.join("app/assets/javascripts")
    end

    initializer "snapshot_inspector.assets.precompile" do |app|
      app.config.assets.precompile += %w[snapshot_inspector/manifest]
    end

    initializer "snapshot_inspector.include_test_helpers" do |_app|
      if defined?(RSpec)
        RSpec.configure do |config|
          config.include SnapshotInspector::Test::RSpecHelpers
          config.after :suite do
            SnapshotInspector::Storage.move_files_from_processing_directory_to_snapshots_directory if SnapshotInspector::Storage.processing_directory.exist?
          end
        end
      else
        ActiveSupport.on_load(:active_support_test_case) do
          include SnapshotInspector::Test::TestUnitHelpers
        end
      end

      ActiveSupport.on_load(:action_mailer) do
        include SnapshotInspector::Test::ActionMailerHeaders
      end
    end

    initializer "snapshot_inspector.configure_default_url_options" do |_app|
      url_options =
        if Rails.application.routes.default_url_options.present?
          Rails.application.routes.default_url_options
        elsif Rails.application.config.action_controller.default_url_options.present?
          Rails.application.config.action_controller.default_url_options
        end

      SnapshotInspector.configuration.host = url_options ? [url_options[:host], url_options[:port]].join(":") : SnapshotInspector.configuration.host
    end

    initializer "snapshot_inspector.register_eml_mime_type" do |_app|
      Mime::Type.register "application/octet-stream", :eml
    end

    config.after_initialize do |app|
      app.routes.prepend do
        mount SnapshotInspector::Engine, at: SnapshotInspector.configuration.route_path
      end
    end
  end
end
