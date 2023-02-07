Rails.application.routes.draw do
  mount Minitest::Snapshot::Engine => "/minitest-snapshot"
end
