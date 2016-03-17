class Pathname
  # Converts cygwin paths to c:/ type paths
  # ex: cygwin_to_dos('/cygdrive/c/tmp') => 'c:/tmp'
  def self.cygwin_to_dos(path)
    if path =~ /^\/cygdrive\//
      path = path.sub(/^\/cygdrive\//,'')
      if path[1] == '/'
        path = path.sub(/\//,':/')
      end
    end
    path
  end
  # Converts, (if possible) the path to the ~ form
  #   ex: if the current user's home directory is
  #   'c:/users/joe' then
  #   Pathname.tildize('c:/users/joe/abc')
  #   will return '~/abc'
  def self.tildize(path)
    newpath = File.absolute_path(path)
    newpath = cygwin_to_dos(newpath)
    r=/#{ENV['HOME']}/i
    if newpath !~ r
      return path
    end
    newpath = newpath.sub(r,'~')
    newpath
  end
end
