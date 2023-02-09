module ViewInspector
  module ApplicationHelper
    def view_inspector_importmap_tags(entry_point = "application", shim: true)
      safe_join(
        [
          javascript_inline_importmap_tag(ViewInspector.configuration.importmap.to_json(resolver: self)),
          javascript_importmap_module_preload_tags(ViewInspector.configuration.importmap),
          (javascript_importmap_shim_nonce_configuration_tag if shim),
          (javascript_importmap_shim_tag if shim),
          javascript_import_module_tag(entry_point)
        ].compact, "\n"
      )
    end
  end
end
