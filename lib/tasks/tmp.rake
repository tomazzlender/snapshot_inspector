require "snapshot_inspector/storage"

namespace :tmp do
  namespace :snapshots do
    desc "Clear all files in the snapshots storage directory (e.g. tmp/snapshots)"
    task :clear do
      SnapshotInspector::Storage.clear
    end
  end
end
