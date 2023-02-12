module ViewInspector
  module Cleaner
    module_function

    def clean_snapshots_from_previous_run
      ViewInspector.configuration.absolute_storage_directory.rmtree
    end
  end
end
