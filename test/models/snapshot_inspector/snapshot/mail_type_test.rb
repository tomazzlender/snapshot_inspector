require "test_helper"

class SnapshotInspector::Snapshot::MailTypeTest < ActiveSupport::TestCase
  class DummyMailer < ActionMailer::Base
    default from: "no-reply@example.com", return_path: "system@example.com"

    def welcome(recipient)
      attachments["mail_attachment.txt"] = SnapshotInspector::Engine.root.join("test/fixtures/files/mail_attachment.txt").read
      mail(
        to: email_address_with_name(recipient.email, recipient.name),
        bcc: ["bcc@example.com"],
        subject: "Welcome!"
      ) do |format|
        format.html { render html: "<html><body>Welcome #{recipient.name}</body></html>" }
      end
    end
  end

  test "::extract" do
    recipient = Struct.new(:name, :email).new(name: "John", email: "john@example.com")
    mail = DummyMailer.welcome(recipient)
    mail_type = SnapshotInspector::Snapshot::MailType.extract(mail)

    assert_equal mail_type.message.subject, "Welcome!"
    assert_equal mail_type.message.to, ["john@example.com"]
    assert_equal mail_type.message.from, ["no-reply@example.com"]
    assert_equal mail_type.message.bcc, ["bcc@example.com"]
    assert_equal mail_type.action_name, "welcome"
    assert_equal mail_type.mailer_name, "snapshot_inspector/snapshot/mail_type_test/dummy_mailer"
    assert_equal mail, mail_type.message
  end

  test "::from_hash" do
    fixture = JSON.parse(file_fixture("user_mailer_test/test_welcome_0.json").read, symbolize_names: true)
    mail_type = SnapshotInspector::Snapshot::MailType.from_hash(fixture[:data])

    assert_equal mail_type.message.subject, "Welcome!"
    assert_equal mail_type.message.to, ["john@example.com"]
    assert_equal mail_type.message.bcc, ["bcc@example.com"]
    assert_equal mail_type.message.from, ["no-reply@example.com"]
  end
end
