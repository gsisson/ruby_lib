# WaitSpinner helps with creating a text-based 'wait spinner' in a console app.
# - This class is mostly from the post at
#   http://stackoverflow.com/questions/10262235/printing-an-ascii-spinning-cursor-in-the-console
# 
# Usage;
#   spinner = WaitSpinner.new
#   while true do
#     spinner.spin
#     long.running(operation)
#   end
#   spinner.stop
class WaitSpinner
  @@chars = %w{| / - \\}
  def initialize (msg)
    @index = 0
    print msg
  end
  # call spin() to updated the spinner (once per long-running loop, for example)
  def spin
    print "\b" if @index > 0
    @index+=1
    print @@chars[@index % @@chars.length]
  end
  # call stop() when done with the loop... to erase the last drawn character
  def stop
    print "\b"
  end
  # call this with a block THAT SLEEPS, and the spinner will run continuously
  # until the block finishes SLEEPING
  # example:
  #
  #   print "Doing something tricky..."
  #   WaitSpinner.show_wait_spinner {
  #     sleep rand(4)+2 # Simulate a task taking an unknown amount of time
  #   }
  #   puts "Done!"
  #
  # Note that it does NOT WORK with long-running NON-SLEEP commands on MRI ruby
  # because MRI ruby has the GIL which means only the 'spinner' code will run or
  # the code in the passed block will run.  In fact, it appears on-sleep code will
  # always run, and the spinner code never gets to run.  For example, change "sleep"
  # above to Dir.glob('/*/**') to find all files and you'll never see the wait spinner.
  def self.show_wait_spinner(fps=10)
    delay = 1.0/fps
    iter = 0
    spinner = Thread.new do
      while iter do  # Keep spinning until told otherwise
        print @@chars[(iter+=1) % @@chars.length]
        sleep delay
        print "\b"
      end
    end
    yield.tap{       # After yielding to the block, save the return value
      iter = false   # Tell the thread to exit, cleaning up after itself
      spinner.join   # and wait for it to do so.
    }                # Use the blocks return value as the methods
  end
end
