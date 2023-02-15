require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "welcome" do
    recepient = Struct.new(:name, :email).new("John", "john@example.com")
    mail = UserMailer.welcome(recepient)

    ViewInspector.configuration.stub(:snapshot_taking_enabled, true) do
      take_snapshot mail
    end

    expected_mail = to_mail(file_fixture("user_mailer_test/test_welcome_0.json"))
    persisted_mail = to_mail(ViewInspector::Storage.processing_directory.join("user_mailer_test/test_welcome_0.json"))
    assert_equal expected_mail.body.decoded, persisted_mail.body.decoded

    assert_equal "Welcome!", persisted_mail.subject
    assert_equal [recepient.email], persisted_mail.to
    # assert_equal ["bcc@example.com"], persisted_mail.bcc
    assert_equal ["no-reply@example.com"], persisted_mail.from
  end

  def to_mail(snapshotee_file_path)
    contents = snapshotee_file_path.read
    json = JSON.parse(contents, symbolize_names: true)
    message_as_string = json[:snapshotee_recording][:message]

    Mail::Message.new(message_as_string)
  end
end
