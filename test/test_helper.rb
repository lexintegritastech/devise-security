# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start do
  add_filter 'gemfiles'
  add_filter 'test/dummy/db'
  add_group 'ActiveRecord', 'active_record'
  add_group 'Expirable', /(?<!password_)expirable/
  add_group 'Mongoid', 'mongoid'
  add_group 'Paranoid Verifiable', 'paranoid_verification'
  add_group 'Password Archivable', /password_archivable|old_password/
  add_group 'Password Expirable', /password_expirable|password_expired/
  add_group 'Secure Validateable', 'secure_validatable'
  add_group 'Security Questionable', 'security_question'
  add_group 'Session Limitable', 'session_limitable'
  add_group 'Tests', 'test'
  add_group 'Password Archivable', 'password_archivable'
  add_group 'Password Expirable', 'password_expirable'
  add_group 'Session Limitable', 'session_limitable'
  add_group 'Session Traceable', 'session_traceable'
end

if ENV['CI']
  require 'simplecov'
  require 'simplecov-lcov'
  SimpleCov.formatter = SimpleCov::Formatter::LcovFormatter
  SimpleCov::Formatter::LcovFormatter.config.report_with_single_file = true
  SimpleCov.start
end

require 'pry'
require 'dummy/config/environment'
require 'minitest/autorun'
require 'rails/test_help'
require 'devise-security'
require 'database_cleaner'
require "orm/#{DEVISE_ORM}"

if Rails.gem_version >= Gem::Version.new('5.0.0')
  require 'rails-controller-testing'
  Rails::Controller::Testing.install
end
require 'support/integration_helpers'

class Minitest::Test
  def before_setup
    DatabaseCleaner.start
  end

  def after_teardown
    DatabaseCleaner.clean
  end
end

require 'mocha/setup'
require 'shoulda'
require 'timecop'
require 'webrat'
Webrat.configure do |config|
  config.mode = :rails
  config.open_error_files = false
end

DatabaseCleaner.clean

# Add support to load paths so we can overwrite broken webrat setup
$LOAD_PATH.unshift File.expand_path('support', __dir__)
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
