require "test_helper"

class ViewInspector::Snapshot::MailerRecordingTest < ActiveSupport::TestCase
  class DummyMailer < ActionMailer::Base
    default from: "no-reply@example.com", return_path: "system@example.com"

    def welcome(recipient)
      @recepient = recipient
      mail(
        to: email_address_with_name(@recepient.email, @recepient.name),
        bcc: ["bcc@example.com"],
        subject: "Welcome!"
      ) do |format|
        format.html { render html: "<html><body>Welcome #{@recepient.name}</body></html>" }
      end
    end
  end

  test "::parse" do
    recipient = Struct.new(:name, :email).new(name: "John", email: "john@example.com")
    mail = DummyMailer.welcome(recipient)
    mail_recording = ViewInspector::Snapshot::MailRecording.parse(mail)

    assert_equal mail_recording.subject, "Welcome!"
    assert_equal mail_recording.to, ["john@example.com"]
    assert_equal mail_recording.from, ["no-reply@example.com"]
  end

  test "#from_json" do
    json = {
      subject: "Welcome!",
      to: ["john@example.com"],
      from: ["no-reply@example.com"]
    }

    mail_recording = ViewInspector::Snapshot::MailRecording.new.from_json(json)

    assert_equal mail_recording.subject, "Welcome!"
    assert_equal mail_recording.to, ["john@example.com"]
    assert_equal mail_recording.from, ["no-reply@example.com"]
  end
end
