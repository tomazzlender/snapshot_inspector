module ViewInspector
  class Snapshot
    class ResponseRecording
      attr_reader :body

      def self.parse(response)
        new.parse(response)
      end

      def parse(response)
        @body = response.parsed_body
        self
      end

      def from_json(json)
        @body = json[:body]
        self
      end
    end
  end
end
