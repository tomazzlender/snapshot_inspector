abort "`minitest-snapshot` is only meant to be loaded in the `development` and `test` environments. Your current environment is `#{Rails.env}`. Move the gem into the `group :development, :test` block in your Gemfile." unless Rails.env.development? || Rails.env.test?

require "minitest/snapshot/version"
require "minitest/snapshot/engine"
require "importmap-rails"

module Minitest
  module Snapshot
    module Test
      autoload :IntegrationHelpers, "minitest/snapshot/test/integration_helpers"
    end

    class << self
      attr_accessor :configuration
    end

    class Configuration
      attr_accessor :importmap, :snapshot_taking_enabled, :storage_directory

      def initialize
        @importmap = Importmap::Map.new
        @snapshot_taking_enabled = false
        @storage_directory = nil
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
end

Minitest::Snapshot.initialize_configuration
