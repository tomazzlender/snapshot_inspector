module SnapshotInspector
  class SnapshotsController < ApplicationController
    def index
      @grouped_by_test_class = Snapshot.grouped_by_test_case
    end
  end
end
