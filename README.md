# ViewInspector

Take snapshots of responses and mailers while working with integration and mailers tests in Ruby on Rails.
Render and inspect snapshots in a browser. Works with a default Ruby on Rails testing framework only (minitest).

> **NOTICE:** the library works great, needs some internal refactoring, and a few more nice to have features.

## Installation
Add the gem to your application's Gemfile under `:development` and `:test` groups. Snapshots are taken in the test environment and inspected in the development environment.

```ruby
group [:development, :test] do
  gem "view_inspector"
end
```

Then execute:
```bash
bundle install
```

## Usage

Start using `take_snapshot` method in the integration tests:

```ruby
test "should get index" do
  get root_path
  
  take_snapshot response # <-- takes a snapshot of the response
  
  assert_response :success
end
```

and in mailer tests:

```ruby
test "welcome mail" do
  mail = NotifierMailer.welcome

  take_snapshot mail # <-- takes a snapshot of the mail

  assert_equal "Welcome!", mail.subject
end
```

Run tests with a flag `--take-snapshots` to enable taking snapshots.

```bash
bin/rails test --take-snapshots
```

Start your local server and visit http://localhost:300/rails/snapshots.

If you wish for the snapshots in a browser to live reload, use a library like [hotwire-livereload](https://github.com/kirillplatonov/hotwire-livereload).
Besides the general installation instructions, add the following lines into `development.rb`.

```ruby
config.hotwire_livereload.listen_paths << ViewInspector::Storage.snapshots_directory
config.hotwire_livereload.force_reload_paths << ViewInspector::Storage.snapshots_directory
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
