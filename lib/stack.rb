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
  def self.backtrace e
    # Returns a backtrace, without the excessively long lines that are hard to read.
    # Usage: Since a backtrace is only of use for unhandled exceptions, Call this from your
    #   last rescue clause (which usually just catches the base exception class "Exception"
    # Example code:
    #   Here is example code calling this method in its 'unhandled exception' handler:
    #
    #     begin
    #       some_code
    #     rescue SomeExceptionType => e
    #       handle_someExceptionType
    #     rescue SomeOtherExceptionType => e
    #       handle_someOtherExceptionType
    #     rescue Exception => e
    #       $stderr.puts ScriptHelper.backtrace e
    #       abort
    #     end
    #
    msg = []
    msg << redbold('ERROR:')+' Unexpected Exception:'
    msg << "       (#{e.class}) "+redbold("#{e.message}")
    msg << "       backtrace: "
    rubypath=""
    e.backtrace.each do |i|
      next if i =~ /.*\/ruby\/gems\//
      next if i =~ /.*\/\.rbenv\//
      msg << "         #{i.sub(ENV['HOME'], '~')}"
    end
    msg
  end
  private
  def self.redbold str
    bold_red="\e[1m\e[31m"
    exit_color="\e[0m"
    "#{bold_red}#{str}#{exit_color}"
  end
end
