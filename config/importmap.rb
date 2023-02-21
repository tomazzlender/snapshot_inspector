require "snapshot_inspector"

SnapshotInspector.configuration.importmap.draw do
  pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
  pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
  pin "stimulus-use", to: "https://ga.jspm.io/npm:stimulus-use@0.51.3/dist/index.js"
  pin "hotkeys-js", to: "https://ga.jspm.io/npm:hotkeys-js@3.10.1/dist/hotkeys.esm.js"

  pin "application", to: "snapshot_inspector/application.js", preload: true

  pin_all_from SnapshotInspector::Engine.root.join("app/assets/javascripts/snapshot_inspector/controllers"), under: "controllers", to: "snapshot_inspector/controllers"
end
