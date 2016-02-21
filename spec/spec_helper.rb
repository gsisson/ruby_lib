if RUBY_PLATFORM !~ /cygwin/
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require 'simplecov'
SimpleCov.start

require 'rspec'

require 'fakefs/spec_helpers'
# to use in tests, add "fakefs: true" as second argument to #describe
RSpec.configure do |config|
  config.include FakeFS::SpecHelpers, fakefs: true
end
