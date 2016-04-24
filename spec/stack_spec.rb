require 'spec_helper'
require_relative '../lib/stack'

def level3(throw_exception)
  throw Exception if throw_exception
  Stack.frames()
end

def level2(throw_exception)
  level3(throw_exception)
end

def level1(throw_exception)
  level2(throw_exception)
end

describe "Stack" do
  describe '#frames' do
    it 'should return stack frames' do
      frames = level1(false)
      # ~/some/path/stack_trace_spec.rb:5:in `level3'
      # ~/some/path/stack_trace_spec.rb:9:in `level2'
      # ~/some/path/stack_trace_spec.rb:13:in `level1'
      # ~/some/path/stack_trace_spec.rb:19:in `block (3 levels) in <top (required)>'
      expect(frames[0]).to match(/#{File.basename(__FILE__)}:[[:digit:]]+:in .level3/i)
      expect(frames[1]).to match(/#{File.basename(__FILE__)}:[[:digit:]]+:in .level2/i)
      expect(frames[2]).to match(/#{File.basename(__FILE__)}:[[:digit:]]+:in .level1/i)
    end
  end
  describe '#backtrace' do
    it 'should have stack info after exception throw' do
      trace = nil
      begin
        throw_exception = true
        level1(throw_exception)
      rescue Exception => e
        trace = Stack.backtrace(e)
      end
      #trace.each { |l| $stderr.puts ":#{l}:" }
      expect(trace.size).to_not be(0)
      expect(trace[0]).to match('Unexpected Exception')
      expect(trace[1]).to match('UncaughtThrowError')
      expect(trace[2]).to match('backtrace:')
      trace[3..-1].each do |trace|
        expect(trace).to match(File.basename(__FILE__))
      end
    end
  end
end
