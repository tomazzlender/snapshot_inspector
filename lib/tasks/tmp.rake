require "view_inspector/cleaner"

namespace :tmp do
  namespace :snapshots do
    desc "Clear all files in the snapshots storage directory (e.g. tmp/snapshots)"
    task :clear do
      ViewInspector::Cleaner.clean_snapshots_from_previous_run
    end
  end
end
