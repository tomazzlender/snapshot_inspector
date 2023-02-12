require "importmap-rails"

module ViewInspector
  class Engine < ::Rails::Engine
    isolate_namespace ViewInspector

    initializer "view_inspector.set_storage_directory" do |_app|
      ViewInspector.configuration.absolute_storage_directory = Rails.root.join(ViewInspector::STORAGE_DIRECTORY)
      ViewInspector.configuration.absolute_processing_directory = Rails.root.join(ViewInspector::PROCESSING_DIRECTORY)
    end

    rake_tasks do
      load "tasks/tmp.rake"
    end

    initializer "view_inspector.importmap", before: "importmap" do |app|
      app.config.importmap.paths << root.join("config/importmap.rb")
      app.config.importmap.cache_sweepers << root.join("app/assets/javascripts")
    end

    initializer "view_inspector.assets.precompile" do |app|
      app.config.assets.precompile += %w[view_inspector/manifest]
    end

    initializer "view_inspector.include_test_integration_helpers" do |_app|
      ActiveSupport.on_load(:action_dispatch_integration_test) do
        include ViewInspector::Test::IntegrationHelpers
      end
    end

    initializer "view_inspector.configure_default_url_options" do |_app|
      url_options =
        if Rails.application.routes.default_url_options.present?
          Rails.application.routes.default_url_options
        elsif Rails.application.config.action_controller.default_url_options.present?
          Rails.application.config.action_controller.default_url_options
        end

      ViewInspector.configuration.host = url_options ? [url_options[:host], url_options[:port]].join(":") : ViewInspector.configuration.host
    end

    config.after_initialize do |app|
      app.routes.prepend do
        mount ViewInspector::Engine, at: ViewInspector.configuration.route_path
      end
    end
  end
end
