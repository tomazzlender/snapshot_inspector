require "importmap-rails"
require "view_inspector/test/action_mailer_headers"

module ViewInspector
  class Engine < ::Rails::Engine
    isolate_namespace ViewInspector

    config.before_configuration do |_app|
      ViewInspector.configuration.storage_directory = Rails.root.join(ViewInspector::STORAGE_DIRECTORY)
    end

    unless Rails.env.test?
      rake_tasks do
        load "tasks/tmp.rake"
      end
    end

    initializer "view_inspector.importmap", before: "importmap" do |app|
      app.config.importmap.paths << root.join("config/importmap.rb")
      app.config.importmap.cache_sweepers << root.join("app/assets/javascripts")
    end

    initializer "view_inspector.assets.precompile" do |app|
      app.config.assets.precompile += %w[view_inspector/manifest]
    end

    initializer "view_inspector.include_test_helpers" do |_app|
      ActiveSupport.on_load(:action_dispatch_integration_test) do
        include ViewInspector::Test::Helpers
      end

      ActiveSupport.on_load(:action_mailer_test_case) do
        include ViewInspector::Test::Helpers
      end

      ActiveSupport.on_load(:action_mailer) do
        include ViewInspector::Test::ActionMailerHeaders
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

    initializer "view_inspector.register_eml_mime_type" do |_app|
      Mime::Type.register "application/octet-stream", :eml
    end

    config.after_initialize do |app|
      app.routes.prepend do
        mount ViewInspector::Engine, at: ViewInspector.configuration.route_path
      end
    end
  end
end
