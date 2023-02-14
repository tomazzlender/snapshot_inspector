# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec features) \
#  .select{|d| Dir.exist?(d) ? d : UI.warning("Directory #{d} does not exist")}

## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"

guard "minitest" do
  watch(%r{^test/(.*)/?test_(.*)\.rb$})
  watch(%r{^lib/(.*/)?([^/]+)\.rb$}) { |m| "test/#{m[1]}test_#{m[2]}.rb" }
  watch(%r{^test/test_helper\.rb$}) { "test" }

  watch(%r{^app/(.+)\.rb$}) { |m| "test/#{m[1]}_test.rb" }
  watch(%r{^app/controllers/application_controller\.rb$}) { "test/controllers" }
  watch(%r{^app/controllers/(.+)_controller\.rb$}) { |m| "test/integration/#{m[1]}_test.rb" }
  watch(%r{^app/views/(.+)_mailer/.+}) { |m| "test/mailers/#{m[1]}_mailer_test.rb" }
  watch(%r{^lib/(.+)\.rb$}) { |m| "test/lib/#{m[1]}_test.rb" }
  watch(%r{^test/.+_test\.rb$})
  watch(%r{^test/test_helper\.rb$}) { "test" }

  # Dummy application
  watch(%r{^test/dummy/test/(.*)/?test_(.*)\.rb$})
  watch(%r{^test/test_helper\.rb$}) { "test/dummy/test" }
  watch(%r{^lib/(.*/)?([^/]+)\.rb$}) { |m| "test/dummy/test/#{m[1]}test_#{m[2]}.rb" }

  watch(%r{^app/(.+)\.rb$}) { |m| "test/dummy/test/#{m[1]}_test.rb" }
  watch(%r{^app/controllers/application_controller\.rb$}) { "test/dummy/test/controllers" }
  watch(%r{^app/controllers/(.+)_controller\.rb$}) { |m| "test/dummy/test/integration/#{m[1]}_test.rb" }
  watch(%r{^app/views/(.+)_mailer/.+}) { |m| "test/dummy/test/mailers/#{m[1]}_mailer_test.rb" }
  watch(%r{^lib/(.+)\.rb$}) { |m| "test/dummy/test/lib/#{m[1]}_test.rb" }
  watch(%r{^test/test_helper\.rb$}) { "test/dummy/test" }

  watch(%r{^test/dummy/app/(.+)\.rb$}) { |m| "test/dummy/test/#{m[1]}_test.rb" }
  watch(%r{^test/dummy/app/controllers/application_controller\.rb$}) { "test/dummy/test/controllers" }
  watch(%r{^test/dummy/app/controllers/(.+)_controller\.rb$}) { |m| "test/dummy/test/integration/#{m[1]}_test.rb" }
  watch(%r{^test/dummy/app/views/(.+)_mailer/.+}) { |m| "test/dummy/test/mailers/#{m[1]}_mailer_test.rb" }
  watch(%r{^test/dummy/lib/(.+)\.rb$}) { |m| "test/dummy/test/lib/#{m[1]}_test.rb" }
end
