# some helper methods to do some things in a friendlier way

module Stack
  # usage example:
  #   require 'stack'
  #   puts Stack.frames(' => ')
  # output:
  #   " => ~/somedir/somepath/some_code_file.rb:16:in `method_1'"
  #   " => ~/somedir/somepath/some_code_file.rb:19:in `method_2'"
  #   " => ~/somedir/somepath/some_code_file.rb:22:in `method_3'"
  def self.frames(prefix = '')
    caller.select do |f|
      f !~ %r{/.rbenv/}
    end.map do |f|
      f.sub(%r{#{ENV['HOME']}},'~').sub(/^/,prefix)
    end
  end
end
