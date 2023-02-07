module Minitest::Snapshot
  class SnapshotsController < ApplicationController
    def index
      @grouped_by_test_class = Snapshot.grouped_by_test_class
    end

    def show
      @snapshot = Snapshot.find(params[:slug])
      render :show, layout: false
    end
  end
end
