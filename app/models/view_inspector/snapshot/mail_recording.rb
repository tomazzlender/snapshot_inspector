module ViewInspector
  class Snapshot
    class MailRecording
      def self.parse(mail)
        new.parse(mail)
      end

      def parse(mail)
        @message = mail.to_s
        self
      end

      def from_json(json)
        @message = json[:message]
        self
      end

      def message
        Mail::Message.new(@message)
      end
    end
  end
end
