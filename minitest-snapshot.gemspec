require_relative "lib/snapshot_inspector/version"

Gem::Specification.new do |spec|
  spec.name = "snapshot_inspector"
  spec.version = SnapshotInspector::VERSION
  spec.authors = ["Tomaz Zlender"]
  spec.email = ["tomaz@zlender.se"]
  spec.homepage = "https://github.com/tomazzlender/snapshot_inspector"
  spec.summary = "Summary of SnapshotInspector."
  spec.description = "Description of SnapshotInspector."
  spec.license = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.4.2"
  spec.add_dependency "stimulus-rails", ">= 1.2.1"
  spec.add_dependency "importmap-rails", ">= 1.1.5"
  spec.add_dependency "sprockets-rails", ">= 3.4.2"
  spec.add_dependency "nokogiri", ">= 1.14.1"
end
