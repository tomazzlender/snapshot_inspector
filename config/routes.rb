ViewInspector::Engine.routes.draw do
  root to: "snapshots#index"

  get "mail/raw/*slug", to: "snapshots/mail_recordings#raw", as: :raw_mail_snapshot
  get "mail/*slug", to: "snapshots/mail_recordings#show", as: :mail_snapshot

  get "response/raw/*slug", to: "snapshots/response_recordings#raw", as: :raw_response_snapshot
  get "response/*slug", to: "snapshots/response_recordings#show", as: :response_snapshot
end
