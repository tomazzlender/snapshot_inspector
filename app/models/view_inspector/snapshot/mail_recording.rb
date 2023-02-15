require "mail"

module ViewInspector
  class Snapshot
    class MailRecording
      def self.parse(mail)
        new.parse(mail)
      end

      def parse(mail)
        @message = mail.to_s
        @bcc = mail.bcc
        self
      end

      def from_json(json)
        @message = json[:message]
        @bcc = json[:bcc]
        self
      end

      def message
        message = Mail::Message.new(@message)
        message.bcc = @bcc
        message
      end

      def mailer_name
        message.header["X-ViewInspector-Mailer-Name"].value
      end

      def action_name
        message.header["X-ViewInspector-Action-Name"].value
      end
    end
  end
end
