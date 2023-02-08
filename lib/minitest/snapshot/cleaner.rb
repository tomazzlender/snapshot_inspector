module Minitest
  module Snapshot
    module Cleaner
      module_function

      def clean_snapshots_from_previous_run
        Minitest::Snapshot.configuration.storage_directory.rmtree
      end
    end
  end
end
