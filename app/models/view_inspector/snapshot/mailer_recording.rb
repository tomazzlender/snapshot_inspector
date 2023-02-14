module ViewInspector
  class Snapshot
    class MailerRecording
      attr_reader :subject, :to, :from

      def self.parse(mailer)
        new.parse(mailer)
      end

      def parse(mailer)
        @subject = mailer.subject
        @to = mailer.to
        @from = mailer.from
        self
      end

      def from_json(json)
        @subject = json[:subject]
        @to = json[:to]
        @from = json[:from]
        self
      end
    end
  end
end
