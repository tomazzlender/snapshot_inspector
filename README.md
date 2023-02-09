# Minitest::Snapshot
Short description and motivation.

## Installation
Add the gem to your application's Gemfile under `:development` group:

```ruby
group :development do
  gem "minitest-snapshot"
end
```

And then execute:
```bash
bundle
```

## Usage

Start using `take_snapshot` method in the integration tests:
```ruby
test "should get index" do
  get root_path
  
  take_snapshot response # <-- take a snapshot of the response
  
  assert_response :success
end
```

Run tests with a flag `--take-snapshots` to enable taking snapshots.

```bash
bin/rails test --take-snapshots
```

Start your local server and visit http://localhost:300/rails/snapshots.

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
