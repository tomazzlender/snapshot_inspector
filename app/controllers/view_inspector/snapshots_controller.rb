module ViewInspector
  class SnapshotsController < ApplicationController
    def index
      @grouped_by_test_class = Snapshot.grouped_by_test_case
    end

    def show
    end

    def raw
      @snapshot = Snapshot.find(params[:slug])
      render :raw, layout: false
    rescue Snapshot::NotFound => error
      @error = error
      render :not_found, status: 404
    end
  end
end
