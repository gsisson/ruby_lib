if RUBY_PLATFORM !~ /cygwin/
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end
require 'simplecov'
SimpleCov.start
