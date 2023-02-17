module ViewInspector
  module SnapshotsHelper
    def self.remove_traces_of_javascript(html)
      doc = Nokogiri.HTML(html)

      doc.css("script").each do |element|
        element.replace("")
      end

      doc.css('link[href$=".js"]').each do |element|
        element.replace("")
      end

      doc.to_html
    end

    def self.snapshot_path(snapshot)
      case snapshot.snapshotee_recording_klass
      when ViewInspector::Snapshot::ResponseRecording
        ViewInspector::Engine.routes.url_helpers.mail_snapshot_path(slug: snapshot.slug)
      when ViewInspector::Snapshot::MailRecording
        ViewInspector::Engine.routes.url_helpers.response_snapshot_path(slug: snapshot.slug)
      end
    end
  end
end
