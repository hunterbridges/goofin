# This CLI inherits the environment configured in environment.rb
# based on the configuration env and scope provided to the `goofin` launcher.

puts "Hello #{$CONFIG[:env]}"
