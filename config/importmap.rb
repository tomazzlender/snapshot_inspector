require "minitest/snapshot"

Minitest::Snapshot.configuration.importmap.draw do
  pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
  pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

  pin "application", to: "minitest/snapshot/application.js", preload: true

  pin_all_from Minitest::Snapshot::Engine.root.join("app/assets/javascripts/minitest/snapshot/controllers"), under: "controllers", to: "minitest/snapshot/controllers"
end
