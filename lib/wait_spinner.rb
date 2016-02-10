#!/usr/bin/env ruby

# http://stackoverflow.com/questions/10262235/printing-an-ascii-spinning-cursor-in-the-console

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
  # call this with a block, and the spinner will run continuously
  # until the block finishes
  # example:
  #   print "Doing something tricky..."
  #   WaitSpinner.show_wait_spinner {
  #     sleep rand(4)+2 # Simulate a task taking an unknown amount of time
  #   }
  #   puts "Done!"

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


