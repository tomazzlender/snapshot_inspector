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

  test "::extract, #message, #mailer_name, #action_name" do
    assert_equal mail_type.message.subject, "Welcome!"
    assert_equal mail_type.message.to, ["john@example.com"]
    assert_equal mail_type.message.from, ["no-reply@example.com"]
    assert_equal mail_type.message.bcc, ["bcc@example.com"]
    assert_equal mail_type.action_name, "welcome"
    assert_equal mail_type.mailer_name, "snapshot_inspector/snapshot/mail_type_test/dummy_mailer"
  end

  test "::from_hash, #message, #mailer_name, #action_name" do
    hash = JSON.parse(mail_type.to_json, symbolize_names: true)
    mail_type_from_hash = SnapshotInspector::Snapshot::MailType.from_hash(hash)

    assert_equal mail_type_from_hash.message.subject, "Welcome!"
    assert_equal mail_type_from_hash.message.to, ["john@example.com"]
    assert_equal mail_type_from_hash.message.bcc, ["bcc@example.com"]
    assert_equal mail_type_from_hash.message.from, ["no-reply@example.com"]
    assert_equal mail_type_from_hash.action_name, "welcome"
    assert_equal mail_type_from_hash.mailer_name, "snapshot_inspector/snapshot/mail_type_test/dummy_mailer"
  end

  private

  def mail
    recipient = Struct.new(:name, :email).new(name: "John", email: "john@example.com")
    DummyMailer.welcome(recipient)
  end

  def mail_type = SnapshotInspector::Snapshot::MailType.extract(mail)
end
