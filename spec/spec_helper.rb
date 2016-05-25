if RUBY_PLATFORM !~ /cygwin/
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require 'simplecov'
SimpleCov.start do
  add_filter '../spec'
  add_group 'lib', '../lib'
end

require 'rspec'

require 'fakefs/spec_helpers'
# to use in tests, add "fakefs: true" as second argument to #describe
RSpec.configure do |config|
  config.include FakeFS::SpecHelpers, fakefs: true
end
