# Minitest::Snapshot
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "minitest-snapshot"
```

And then execute:
```bash
bundle
```

Now you can start using `take_snapshot` method in integration tests:
```ruby
test "should get index" do
  get root_path
  
  take_snapshot response # <-- take a snapshot of the response
  
  assert_response :success
end
```

Run tests with a flag `--with-snapshots` that enables taking snapshots.

```bash
bin/rails test --with-snapshots
```

Start your local server and visit http://localhost:300/rails/snapshots.

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
