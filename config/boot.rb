ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
require 'dotenv'
env_file_path = "config/env.custom"
if File.exists?(env_file_path)
 Dotenv.load(env_file_path)
end
