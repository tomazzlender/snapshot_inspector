namespace :tmp do
  namespace :snapshots do
    desc "Clear all files in tmp/snapshots"
    task :clear do
      Rails.root.join("tmp", "snapshots").rmtree
    end
  end
end
