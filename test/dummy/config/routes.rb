Rails.application.routes.draw do
  mount Minitest::Snapshot::Engine => "/rails/snapshots"
end
