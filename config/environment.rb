# environment.rb
require 'rubygems'
require 'bundler/setup'
require 'active_support/all'
require 'yaml'
require 'json'

# Here you can require any other libraries you may need app-wide.

$CONFIG_ROOT = File.expand_path(File.dirname(__FILE__))
$CONTAINER_ROOT = File.expand_path(File.dirname($CONFIG_ROOT))
$APP_ROOT = ENV['APP_ROOT']
$APP_ROOT ||= "#{$CONTAINER_ROOT}/app/"

puts "Starting application in app root #{$APP_ROOT}"

# Libs
Dir.glob("#{$APP_ROOT}/{lib,models,jobs}/**/*.rb").each do |file|
  require file
end

# Templates
templates = {}
Dir.glob("#{$APP_ROOT}/templates/**/*.mustache") do |template|
  key = File.basename(template, '.*').to_sym
  val = File.open(template, 'r') { |f| f.read }
  templates[key] = val
end
$TEMPLATES = templates

print "Determining config environment... "

env = ENV['CONFIG_ENV']
env ||= 'development'

# Env config
puts "Configuring environment '#{env}'... "
config_file = "#{$CONTAINER_ROOT}/config/environments/#{env}.yaml"
config_hash = Hash.transform_keys_to_symbols YAML.load_file(config_file)
$CONFIG = Configurator.new(config_hash)

################################################################################
# Below this you can put any other global initialization code.
# Anything env-specific should go in the initializers.
################################################################################

# Your Code Here

################################################################################
################################################################################

require "#{$CONTAINER_ROOT}/config/initializers/#{env}.rb"
