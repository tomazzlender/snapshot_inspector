module SnapshotInspector
  class Snapshot
    class ResponseType < Type
      snapshotee ActionDispatch::TestResponse

      attr_reader :body

      def extract(snapshotee)
        @body = snapshotee.parsed_body
      end

      def from_hash(hash)
        @body = hash[:body]
      end
    end
  end
end
