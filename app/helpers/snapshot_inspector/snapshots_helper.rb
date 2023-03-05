module SnapshotInspector
  module SnapshotsHelper
    def prepare_for_render(body, enable_javascript:)
      prepared =
        if enable_javascript == "true"
          body
        else
          remove_traces_of_javascript(body)
        end

      prepared.html_safe
    end

    def remove_traces_of_javascript(html)
      doc = Nokogiri.HTML(html)

      doc.css("script").each do |element|
        element.replace("")
      end

      doc.css('link[href$=".js"]').each do |element|
        element.replace("")
      end

      doc.to_html
    end

    def self.snapshot_path(snapshot, enable_javascript:)
      case snapshot.type
      when "mail"
        SnapshotInspector::Engine.routes.url_helpers.mail_snapshot_path(slug: snapshot.slug)
      when "response"
        SnapshotInspector::Engine.routes.url_helpers.response_snapshot_path(slug: snapshot.slug, enable_javascript: enable_javascript)
      end
    end
  end
end
