require_relative 'date2'
require_relative 'wait_spinner.rb'

# Some useful methods on directories
class Dir2
  # fix Dir.pwd, which returns "/cygdrive/c/" instead of "c:/"
  def self.pwd
    # for RUBY_PLATFORM =~ /cygwin/
    Dir.pwd.sub(/\/cygdrive\/([a-z])/,'\1:')
  end
  # glob case-insensitively with "_i" version (simpler to call)
  def self.glob_i(pattern)
    Dir.glob(pattern, File::FNM_CASEFOLD)
  end
  # glob case-insensitively with []
  def self.[](pattern)
    glob_i(pattern)
  end
  # glob recursively for files
  def self.all_files_recursively()
    glob_i('**/*')
  end
  # glob recursively for dirs
  def self.all_dirs_recursively()
    glob_i('**/*/')
  end
  # Useful to find just file types
  def self.symlink_or_directory?(f)
    # doesn't seem to work on Mac ???
    #  File.symlink?(f)
    require_relative 'file_symlink'
    return File.symlink?(f) || File.directory?(f)
  end
  ##########################################################################################
  # find by TYPE
  ##########################################################################################
  # return all that are files
  def self.files(glob_arg)
    Dir2.glob_i(glob_arg).select do |f|
      File.exist?(f) && !File.directory?(f) && !File.symlink?(f)
    end
  end
  # return all that are directories or symbolic links
  def self.dir_or_symlink(glob_arg)
    Dir2.glob_i(glob_arg).select do |f|
      File.symlink?(f) || Dir.exist?(f)
    end
  end
  ##########################################################################################
  # find files by EXTENSION
  ##########################################################################################
  # return all jpgs, case insensitive
  def self.glob_i_jpgs
    glob_i("*.{jpg,jpeg}")
  end
  # return all lnks, case insensitive
  def self.glob_i_lnks
    glob_i("*.lnk")
  end
  # return all jpgs+cr2 files, case insensitive
  def self.glob_i_jpgs_cr2s
    glob_i("*.{jpg,jpeg,cr2}")
  end
  # return all images, case insensitive
  def self.glob_i_images_movies
    glob_i("*.{bmp,jpg,jpeg,png,gif,avi,wmv,mov,mpg,mpeg,mpe}")
  end
  def self.glob_i_images_movies_and_text
    glob_i("*.{bmp,jpg,jpeg,png,gif,avi,wmv,mov,mpg,mpeg,mpe,txt}")
  end
  ##########################################################################################
  # find files and flatten
  ##########################################################################################
  # return the union of all the non-directory files found in all the directories passed
  # ex: Dir2.files_in_dirs( [ '.', '.ssh' ] )
  @entries = {}
  def self.files_in_dirs(dir_array, options = {})
    prob_dirs = find_non_dirs_and_non_symbols_PRIVATE(dir_array)
    if prob_dirs.size > 0
      if options[:verbose]
        puts "ERROR: directories do not exist:"
        prob_dirs.each do |d|
          puts "  #{d}"
        end
      end
      return nil 
    end
    all_files=[]
    dir_array.each do |d|
      d=File.absolute_path(d)
      d.downcase!
      files = @entries[d]
      if ! files
        print "loading '#{File.basename(d)}'..." if options[:verbose]
        files = Dir.entries(d)
        files = files[1..-1] if files.size >= 1 && files[0] == '.'
        files = files[1..-1] if files.size >= 1 && files[0] == '..'
        @entries[d] = files
        puts files.size if options[:verbose]
      end
      fast = true
      if ! fast
        files.select! do |f|
          # TODO: why not just call File.exist?() to ensure getting files, and no symlinks?
          #       ...I think it doesn't correctly return false for File.exist?(some_symlink)
          ! symlink_or_directory?(f)
        end
      end
      if all_files.size == 0
        #puts "avoiding .push()..."
        all_files = files.clone
      else
        #puts all_files.size
        #puts files.size
        #puts "pushing..."
        all_files.push(*files)
      end
      all_files.uniq!
    end
    all_files.sort!
  end
  ##########################################################################################
  # DATE TIME format related methods for file/dir names
  ##########################################################################################
  # does the passed string contain a date-time prefix?
  #  "2005-23-10_23.23.23_DEF" => true
  #  "2005-23-10"              => false
  def self.date_time_prefix?(directory)
    date_time_prefix(directory) ? true : false
  end
  # return the date-time prefix of the passed string
  #  "2005-23-10_23.23.23_DEF" => "2005-23-10_23.23.23"
  #  "2005-23-10"              => nil
  def self.date_time_prefix(directory)
    dtp=File.basename(directory)[0..18]
    return nil if ! Date2.valid_date_time?(dtp)
    Date2.prefix_for_file(dtp)
  end
  # does the passed string contain a date-time prefix?
  #  "2005-23-10_DEF" => true
  #  "2005-23-XX"     => false
  def self.date_prefix?(directory)
    date_prefix(directory) ? true : false
  end
  # return the date prefix of the passed string
  #  "2005-23-10_DEF" => "2005-23-10"
  #  "2005-23-XX"     => nil
  def self.date_prefix(directory)
    dtp=File.basename(directory)[0..9]
    return nil if ! Date2.valid_date?(dtp)
    Date2.prefix_for_file(dtp)
  end
  # PRIVATE PRIVATE PRIVATE PRIVATE PRIVATE PRIVATE PRIVATE PRIVATE PRIVATE
  # PRIVATE PRIVATE PRIVATE PRIVATE PRIVATE PRIVATE PRIVATE PRIVATE PRIVATE
  # PRIVATE PRIVATE PRIVATE PRIVATE PRIVATE PRIVATE PRIVATE PRIVATE PRIVATE
  private
  # given an array, return an array of all then non-symbol/non-directory items in the array
  def self.find_non_dirs_and_non_symbols_PRIVATE(dir_array)
    prob_dirs = []
    dir_array.each do |d|
      if ! d.instance_of? Symbol
        prob_dirs << d if ! Dir.exist? d
      end
    end
    prob_dirs
  end
  # are the files hard linked?
  def self.ino_eq(f1,f2)
    File.stat(f1).ino == File.stat(f2).ino
  end
end
