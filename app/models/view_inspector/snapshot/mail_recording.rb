module ViewInspector
  class Snapshot
    class MailRecording
      attr_reader :subject, :to, :from

      def self.parse(mail)
        new.parse(mail)
      end

      def parse(mail)
        @message = mail.to_s
        @subject = mail.subject
        @to = mail.to
        @from = mail.from
        self
      end

      def from_json(json)
        @message = json[:message]
        @subject = json[:subject]
        @to = json[:to]
        @from = json[:from]
        self
      end

      def message
        Mail::Message.new(@message)
      end
    end
  end
end
