require 'appscript'

# This class has methods for creating tabs in the OSX Terminal utility, naming the tabs
# and running commands in the tabs.
class OsxTerminal
  attr_accessor :term
  def initialize
    extend Appscript
    @term = app('Terminal')
    # tab = @term.windows.first.tabs.last
    @set_titles = true
  end
  def tabify(commands)
    make_window
    run commands
    @term.windows.first.tabs.first.selected.set true
  end
# protected
  def run(commands) #------------------------------------------------------------------------
    commands.each_with_index do |command, idx|
      if command.class == Array
        (title, command) = command
      else
        title = command
      end
      new_tab = (idx > 0)
      tab = make_tab title, new_tab
      sleep(0.20)
      @term.do_script(command, :in => tab)
    end
  end
  def make_window #-------------------------------------------------------------------------
    @term.activate
    app("System Events").application_processes[ "Terminal.app" ].keystroke("n", :using => :command_down)
  end
  def make_tab(title=nil, new_tab = true) #-------------------------------------------------
puts "make_tab(title:#{title},new_tab:#{new_tab})"
    @term.activate app("System Events").application_processes[ "Terminal.app" ].keystroke("t", :using => :command_down) if new_tab
    tab = @term.windows.first.tabs.last
    tab.selected.set true
    set_selected_tab_title title if @set_titles && title
    tab
  end
  def set_selected_tab_title(title) #-----------------------------------------------------
    @term.activate app("System Events").application_processes[ "Terminal.app" ].keystroke("I", :using => :command_down) #open tab editor
    @term.activate app("System Events").application_processes[ "Terminal.app" ].keystroke(title) #enter tile
    @term.activate app("System Events").application_processes[ "Inspector" ].keystroke("w", :using => :command_down) #close inspector\
    sleep(0.15)
  end
end
