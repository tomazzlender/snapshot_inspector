SnapshotInspector::Engine.routes.draw do
  root to: "snapshots#index"

  get "mail/raw/*slug", to: "snapshots/mail#raw", as: :raw_mail_snapshot
  get "mail/*slug", to: "snapshots/mail#show", as: :mail_snapshot

  get "response/raw/*slug", to: "snapshots/response#raw", as: :raw_response_snapshot
  get "response/*slug", to: "snapshots/response#show", as: :response_snapshot
end
