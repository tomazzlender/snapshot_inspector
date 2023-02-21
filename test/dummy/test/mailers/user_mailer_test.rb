require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "welcome" do
    recepient = Struct.new(:name, :email).new("John", "john@example.com")
    mail = UserMailer.welcome(recepient)

    SnapshotInspector.configuration.stub(:snapshot_taking_enabled, true) do
      take_snapshot mail
    end

    persisted_mail = to_mail(SnapshotInspector::Storage.processing_directory.join("user_mailer_test/test_welcome_0.json"))

    assert_equal "Welcome!", persisted_mail.subject
    assert_equal [recepient.email], persisted_mail.to
    assert_equal ["bcc@example.com"], persisted_mail.bcc
    assert_equal ["no-reply@example.com"], persisted_mail.from
  end

  test "reminder" do
    recepient = Struct.new(:name, :email).new("John", "john@example.com")
    mail = UserMailer.reminder(recepient)

    SnapshotInspector.configuration.stub(:snapshot_taking_enabled, true) do
      take_snapshot mail
    end

    persisted_mail = to_mail(SnapshotInspector::Storage.processing_directory.join("user_mailer_test/test_reminder_0.json"))

    assert_equal "Remember to take care of...", persisted_mail.subject
    assert_equal [recepient.email], persisted_mail.to
    assert_nil persisted_mail.bcc
    assert_equal ["no-reply@example.com"], persisted_mail.from
  end

  test "plaintext" do
    recepient = Struct.new(:name, :email).new("John", "john@example.com")
    mail = UserMailer.plaintext(recepient)

    SnapshotInspector.configuration.stub(:snapshot_taking_enabled, true) do
      take_snapshot mail
    end

    persisted_mail = to_mail(SnapshotInspector::Storage.processing_directory.join("user_mailer_test/test_plaintext_0.json"))

    assert_equal "Plain text is back", persisted_mail.subject
    assert_equal [recepient.email], persisted_mail.to
    assert_nil persisted_mail.bcc
    assert_equal ["no-reply@example.com"], persisted_mail.from
  end

  def to_mail(snapshotee_file_path)
    contents = JSON.parse(snapshotee_file_path.read, symbolize_names: true)
    SnapshotInspector::Snapshot::MailType.from_hash(contents[:data]).message
  end
end
