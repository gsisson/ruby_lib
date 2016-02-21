require 'spec_helper'
require_relative '../lib/stack_trace'

def level3
  StackTrace.my_frames()
end

def level2
  level3
end

def level1
  level2
end

describe "StackTrace" do
  describe '#my_frames' do
    it 'should return stack frames' do
      frames = level1
      # ~/some/path/stack_trace_spec.rb:5:in `level3'
      # ~/some/path/stack_trace_spec.rb:9:in `level2'
      # ~/some/path/stack_trace_spec.rb:13:in `level1'
      # ~/some/path/stack_trace_spec.rb:19:in `block (3 levels) in <top (required)>'
      expect(frames[0]).to match(/#{File.basename(__FILE__)}:[[:digit:]]+:in .level3/i)
      expect(frames[1]).to match(/#{File.basename(__FILE__)}:[[:digit:]]+:in .level2/i)
      expect(frames[2]).to match(/#{File.basename(__FILE__)}:[[:digit:]]+:in .level1/i)
    end
  end
end
