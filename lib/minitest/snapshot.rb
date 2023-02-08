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
      attr_accessor :importmap

      def initialize
        @importmap = Importmap::Map.new
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
