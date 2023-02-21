class UserMailer < ApplicationMailer
  default from: "no-reply@example.com", return_path: "system@example.com"

  def welcome(recipient)
    @recepient = recipient
    mail(
      to: email_address_with_name(@recepient.email, @recepient.name),
      bcc: ["bcc@example.com"],
      subject: "Welcome!"
    ) do |format|
      format.html
      format.text
    end
  end

  def reminder(recipient)
    @recepient = recipient
    attachments["mail_attachment.txt"] = SnapshotInspector::Engine.root.join("test/fixtures/files/mail_attachment.txt").read
    mail(
      to: email_address_with_name(@recepient.email, @recepient.name),
      subject: "Remember to take care of..."
    )
  end

  def plaintext(recipient)
    @recepient = recipient
    mail(
      to: email_address_with_name(@recepient.email, @recepient.name),
      subject: "Plain text is back"
    ) do |format|
      format.text
    end
  end
end
