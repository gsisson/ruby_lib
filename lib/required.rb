# 'required' is like 'require', but prints out the essential useful
# information when the required file can't be found (rather than just
# throwing an exception with a stack trace).  To do this, you need to
# pass the name of the gem that the required file is from

# example usage:
#   require 'required'
#   required 'appscript',      'rb-appscript'
#   required 'some_ruby_file'
def required(gem_name, gem_install_name = nil)
  Required::require gem_name, gem_install_name
end

require_relative 'pathname2'

module Required
  BOLD_RED="\033[1m\033[31m"
  EXIT_COLOR="\033[0m"
  def self.require gem_name, gem_install_name
    begin
      Kernel.require gem_name
    rescue LoadError => e
      # caller[2] should be something like: "./some_file.rb:80:in '<main>'"
      # we just need to extract the file name and line number
      match = /(.*):(\d):/.match(caller[2])
      if match && match[1] && match[2]
        script_name, line_no = match[1..2]
        caller="#{script_name}, line #{line_no}"
        if e.message =~ /#{gem_name}/
          script_proj = File.absolute_path(script_name)
          script_name = File.basename(script_name)
          while true
            break if script_proj == '/'
            script_proj = File.dirname(script_proj)
            break if Dir.exist? File.join(script_proj,'.git')
          end
          script_proj = Pathname.tildize(File.absolute_path(script_proj))
          msg = %Q{\n#{BOLD_RED}File "#{gem_name}" not found (required from #{caller})#{EXIT_COLOR}\n}
          if gem_install_name
            msg = msg + %Q{#{BOLD_RED}Please install in #{script_proj} }
            msg = msg + %Q{with "gem install #{gem_install_name}"#{EXIT_COLOR}}
          end
          raise msg
        end
      end
      raise
    end
  end
end
