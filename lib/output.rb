# (c) Kevin Skoklund - Lynda.com

# useful for TDD
#  - capture output from command line programs and validate

# no_ouput do
#   ... code here
# end

def no_output(&block)
  original_stdout = $stdout.dup
  $stdout.reopen('/dev/null')
  $stdout.sync = true
  begin
    yield
  ensure
    $stdout.reopen(original_stdout)
  end
end

# s = capture_ouput do
#   ... code here
# end
# puts s

def capture_output(&block)
  original_stdout = $stdout.dup
  output_catcher = StringIO.new
  $stdout = output_catcher
  begin
    yield
  ensure
    $stdout = original_stdout
  end
  output_catcher.string
end
