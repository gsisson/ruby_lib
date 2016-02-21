# Print the stack frames, but not the frames from gems, or built-in ruby libraries
class StackTrace
  # usage example:
  # StackTrace.my_frames(' => ')
  # => ~/somedir/somepath/some_code_file.rb:16:in `method_1'
  # => ~/somedir/somepath/some_code_file.rb:19:in `method_2'
  # => ~/somedir/somepath/some_code_file.rb:22:in `method_3'
  def self.my_frames(prefix = '')
    caller.select do |f|
      f !~ %r{/.rbenv/}
    end.map do |f|
      f.sub(%r{#{ENV['HOME']}},'~').sub(/^/,prefix)
    end
  end
end
