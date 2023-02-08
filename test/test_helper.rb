# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
require "rails/test_help"
require "minitest/mock"
require "test_helpers/environment_helper"

ActiveSupport::TestCase.file_fixture_path = Minitest::Snapshot::Engine.root + "test/fixtures/files"
