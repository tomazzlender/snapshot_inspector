module Minitest::Snapshot
  class SnapshotsController < ApplicationController
    def index
      @snapshots = Snapshot.all
    end

    def show
      @snapshot = Snapshot.find(params[:slug])
      render :show, layout: false
    end
  end
end
