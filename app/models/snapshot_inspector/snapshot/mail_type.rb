require "mail"

module SnapshotInspector
  class Snapshot
    class MailType < Type
      snapshotee ActionMailer::MessageDelivery

      def extract(snapshotee)
        @message = snapshotee.to_s
        @bcc = snapshotee.bcc
      end

      def from_hash(hash)
        @message = hash[:message]
        @bcc = hash[:bcc]
      end

      def message
        message = Mail::Message.new(@message)
        message.bcc = @bcc
        message
      end

      def mailer_name
        message.header["X-SnapshotInspector-Mailer-Name"].value
      end

      def action_name
        message.header["X-SnapshotInspector-Action-Name"].value
      end
    end
  end
end
