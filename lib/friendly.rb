# some helper methods to do some things in a friendlier way

module Friendly
  # Friendly::require 'fileutils', 'Kernel', __FILE__
  def self.require gem_name, gem_install_name, script_name
    begin
      Kernel.require gem_name
    rescue LoadError => e
      bold_red="\e[1m\e[31m"
      exit_color="\e[0m"
      if e.message =~ /#{gem_name}/
        script_proj = File.dirname(File.absolute_path(script_name))
        while true
          break if script_proj == '/'
          script_proj = File.dirname(script_proj)
          break if Dir.exist? File.join(script_proj,'.git')
        end
        script_proj = script_proj.sub(/#{ENV['HOME']}/,'~')
        STDERR.puts  %Q{#{bold_red}Gem "#{gem_name}" not found in project #{script_proj}#{exit_color}}
        abort        %Q{#{bold_red}Please install with "gem install #{gem_install_name}"#{exit_color}}
        raise msg
      end
      raise
    end
  end
  # usage example:
  #   require 'friendly'
  #   Friendly.stack_trace(' => ')
  # output:
  #   " => ~/somedir/somepath/some_code_file.rb:16:in `method_1'"
  #   " => ~/somedir/somepath/some_code_file.rb:19:in `method_2'"
  #   " => ~/somedir/somepath/some_code_file.rb:22:in `method_3'"
  def self.stack_frames(prefix = '')
    caller.select do |f|
      f !~ %r{/.rbenv/}
    end.map do |f|
      f.sub(%r{#{ENV['HOME']}},'~').sub(/^/,prefix)
    end
  end
end
