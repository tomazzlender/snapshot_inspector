abort "`view_inspector` is only meant to be loaded in the `development` and `test` environments. Your current environment is `#{Rails.env}`. Move the gem into the `group :development, :test` block in your Gemfile." unless Rails.env.development? || Rails.env.test?

require "view_inspector/version"
require "view_inspector/engine"
require "minitest/view_inspector_plugin"
require "importmap-rails"

module ViewInspector
  module Test
    autoload :Helpers, "view_inspector/test/helpers"
  end

  STORAGE_DIRECTORY = "tmp/view_inspector"

  class << self
    attr_accessor :configuration
  end

  class Configuration
    attr_accessor :importmap, :snapshot_taking_enabled, :storage_directory, :host, :route_path

    def initialize
      @importmap = Importmap::Map.new
      @snapshot_taking_enabled = false
      @storage_directory = nil
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
