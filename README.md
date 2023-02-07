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
$ bundle
```

Or install it yourself as:
```bash
$ gem install minitest-snapshot
```

Add integration tests helper to `test/test_helper.rb`:
```ruby
class ActiveSupport::TestCase
  # ...
  include Minitest::Snapshot::Test::IntegrationHelpers
end
```

Start using `take_snapshot` method in integration tests:
```ruby
test "should get index" do
  get root_path
  
  take_snapshot response # <-- take a snapshot of the response
  
  assert_response :success
end
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
