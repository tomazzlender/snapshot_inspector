module ViewInspector
  module SnapshotsHelper
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
  end
end
