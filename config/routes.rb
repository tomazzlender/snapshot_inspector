ViewInspector::Engine.routes.draw do
  root to: "snapshots#index"
  get "raw/*slug", to: "snapshots#raw", as: :raw_snapshot
  get "*slug", to: "snapshots#show", as: :snapshot
end
