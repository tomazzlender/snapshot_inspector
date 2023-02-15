require "test_helper"

class ViewInspector::Snapshot::MailRecordingTest < ActiveSupport::TestCase
  class DummyMailer < ActionMailer::Base
    default from: "no-reply@example.com", return_path: "system@example.com"

    def welcome(recipient)
      attachments["mail_attachment.txt"] = ViewInspector::Engine.root.join("test/fixtures/files/mail_attachment.txt").read
      mail(
        to: email_address_with_name(recipient.email, recipient.name),
        bcc: ["bcc@example.com"],
        subject: "Welcome!"
      ) do |format|
        format.html { render html: "<html><body>Welcome #{recipient.name}</body></html>" }
      end
    end
  end

  test "::parse" do
    recipient = Struct.new(:name, :email).new(name: "John", email: "john@example.com")
    mail = DummyMailer.welcome(recipient)
    mail_recording = ViewInspector::Snapshot::MailRecording.parse(mail)

    assert_equal mail_recording.message.subject, "Welcome!"
    assert_equal mail_recording.message.to, ["john@example.com"]
    assert_equal mail_recording.message.from, ["no-reply@example.com"]
    assert_equal mail_recording.message.bcc, ["bcc@example.com"]
    assert_equal mail_recording.action_name, "welcome"
    assert_equal mail_recording.mailer_name, "view_inspector/snapshot/mail_recording_test/dummy_mailer"
    assert_equal mail, mail_recording.message
  end

  test "#from_json" do
    fixture = JSON.parse(file_fixture("user_mailer_test/test_welcome_0.json").read, symbolize_names: true)
    mail_recording = ViewInspector::Snapshot::MailRecording.new.from_json(fixture[:snapshotee_recording])

    assert_equal mail_recording.message.subject, "Welcome!"
    assert_equal mail_recording.message.to, ["john@example.com"]
    assert_equal mail_recording.message.bcc, ["bcc@example.com"]
    assert_equal mail_recording.message.from, ["no-reply@example.com"]
  end
end
