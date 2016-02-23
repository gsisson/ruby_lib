# http://stackoverflow.com/questions/21511347/how-to-create-a-symlink-on-windows-via-ruby

require 'open3'

class << File
  alias_method :old_symlink,  :symlink
  alias_method :old_symlink?, :symlink?

  # Replace the built-in #symlink, so that Windows can be handled
  def symlink(existing_name, new_name)
    if RUBY_PLATFORM =~ /mswin32|cygwin|mingw|bccwin/
      #windows mklink syntax is reverse of unix ln -s
      #windows mklink is built into cmd.exe
      _stdin, _stdout, _stderr, wait_thr =
        Open3.popen3('cmd.exe', "/c mklink /d #{new_name.tr('/','\\')} #{existing_name.tr('/','\\')}")
      wait_thr.value.exitstatus
    else
      self.old_symlink(existing_name, new_name)
    end
  end
  # Replace the built-in #symlink?, so that Windows can be handled
  def symlink?(file_name)
    if RUBY_PLATFORM =~ /mswin32|cygwin|mingw|bccwin/
      symlink_windows?(file_name)
    else
      self.old_symlink?(file_name)
    end
  end
  # Check if a file is a symbolic link on Windows.  Do not call, if not on windows
  def symlink_windows?(file_name)
    dirname = File.dirname(file_name)
    return false if ! File.directory?(dirname)
    pwd = Dir.pwd
    begin
      Dir.chdir dirname
      file_name = File.basename(file_name)
      dir_cmd = 'cmd.exe /c dir'
      _stdin, stdout, stderr, wait_thr = Open3.popen3(dir_cmd)
      exit_status = ( wait_thr.value.exitstatus == 0 )
      stdout = stdout.read.split(%r{\r?\n})
      stderr = stderr.read.split(%r{\r?\n})
      if ! exit_status
        STDERR.puts "ERROR: unable to run command: \"#{dir_cmd}\""
        STDERR.puts stderr.map {|line| "  #{line}"}
        return exit_status
      end
      #stdout.each { |line| puts "==> #{line}" }
      hits = stdout.select do |line|
        line =~ /<SYMLINKD?>\s+#{file_name}\s+/
      end
      return hits.size > 0
    ensure
      Dir.chdir pwd
    end
  end
end
