class UserMailer < ApplicationMailer
  default from: "no-reply@example.com", return_path: "system@example.com"

  def welcome(recipient)
    @recepient = recipient
    mail(
      to: email_address_with_name(@recepient.email, @recepient.name),
      bcc: ["bcc@example.com"],
      subject: "Welcome!"
    )
  end
end
