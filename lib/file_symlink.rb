class << File
  alias_method :old_symlink,  :symlink

  def symlink(old_name, new_name)
    #if on windows, call mklink, else self.symlink
    if RUBY_PLATFORM =~ /mswin32|cygwin|mingw|bccwin/
      #windows mklink syntax is reverse of unix ln -s
      #windows mklink is built into cmd.exe
      #vulnerable to command injection, but okay because this is a hack to make a cli tool work.
      _stdin, _stdout, _stderr, wait_thr = Open3.popen3('cmd.exe', "/c mklink /d #{new_name.tr('/','\\')} #{old_name.tr('/','\\')}")
      wait_thr.value.exitstatus
    else
      self.old_symlink(old_name, new_name)
    end
  end
end
