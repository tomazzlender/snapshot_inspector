require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "welcome" do
    recepient = Struct.new(:name, :email).new("John", "john@example.com")
    mail = UserMailer.welcome(recepient)
    assert_equal "Welcome!", mail.subject
    assert_equal [recepient.email], mail.to
    assert_equal ["bcc@example.com"], mail.bcc
    assert_equal ["no-reply@example.com"], mail.from
    expected_body = "<!DOCTYPE html>\r\n<html>\r\n  <head>\r\n    <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />\r\n    <style>\r\n      /* Email styles need to be inline */\r\n    </style>\r\n  </head>\r\n\r\n  <body>\r\n    <main>\r\n  <h1>Welcome John!</h1>\r\n  <p>We are happy to have you.</p>\r\n</main>\r\n\r\n  </body>\r\n</html>\r\n"
    assert_match expected_body, mail.body.encoded
  end
end
