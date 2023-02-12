abort "`view_inspector` is only meant to be loaded in the `development` and `test` environments. Your current environment is `#{Rails.env}`. Move the gem into the `group :development, :test` block in your Gemfile." unless Rails.env.development? || Rails.env.test?

require "view_inspector/version"
require "view_inspector/engine"
require "minitest/view_inspector_plugin"
require "importmap-rails"

module ViewInspector
  module Test
    autoload :IntegrationHelpers, "view_inspector/test/integration_helpers"
  end

  class << self
    attr_accessor :configuration
  end

  STORAGE_DIRECTORY = "tmp/view_inspector/snapshots"
  PROCESSING_DIRECTORY = "tmp/view_inspector/processing"

  class Configuration
    attr_accessor :importmap, :snapshot_taking_enabled, :absolute_storage_directory, :absolute_processing_directory, :host, :route_path

    def initialize
      @importmap = Importmap::Map.new
      @snapshot_taking_enabled = false
      @absolute_storage_directory = nil
      @absolute_processing_directory = nil
      @host = "http://localhost:3000"
      @route_path = "/rails/snapshots"
    end
  end

  def self.initialize_configuration
    self.configuration ||= Configuration.new
  end

  def self.configure
    initialize_configuration
    yield(configuration)
  end
end

ViewInspector.initialize_configuration
