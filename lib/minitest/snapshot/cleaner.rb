module Minitest
  module Snapshot
    module Cleaner
      module_function

      def clean_snapshots_from_previous_run
        Rails.root.join("tmp", "snapshots").rmtree
      end
    end
  end
end
