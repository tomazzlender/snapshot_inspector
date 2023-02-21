module SnapshotInspector
  class Snapshots::ResponseController < ApplicationController
    rescue_from Snapshot::NotFound, with: :snapshot_not_found

    layout false, only: [:raw]

    def show
      @snapshot = Snapshot.find(params[:slug])
    end

    def raw
      @snapshot = Snapshot.find(params[:slug])
    end
  end
end
