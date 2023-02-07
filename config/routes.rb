Minitest::Snapshot::Engine.routes.draw do
  root to: "snapshots#index"
  get "*slug", to: "snapshots#show", as: :snapshot
end
