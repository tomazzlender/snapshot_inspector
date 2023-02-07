module Minitest::Snapshot
  class SnapshotsController < ApplicationController
    def index
      @snapshots = Snapshot.all
    end
  end
end
