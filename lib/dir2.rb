require_relative 'date2'

# Some useful methods on directories
class Dir2
  # Simpler way to glob case-insensitively
  def self.globi(pattern)
    Dir.glob(pattern, File::FNM_CASEFOLD)    
  end
  # return all jpgs, case insensitive
  def self.globi_jpgs
    globi("*.{jpg,jpeg}")
  end
  # return all jpgs+cr2 files, case insensitive
  def self.globi_jpgs_cr2s
    globi("*.{jpg,jpeg,cr2}")
  end
  # return all images, case insensitive
  def self.globi_images
    globi("*.{jpg,jpeg,png,gif,avi,wmv,mov,mpg,mpeg,mpe}")
  end
  def self.globi_images_and_text
    globi("*.{jpg,jpeg,png,gif,avi,wmv,mov,mpg,mpeg,mpe,txt}")
  end
  # return all that are files
  def self.files(glob_arg)
    Dir2.globi(glob_arg).select do |f|
      File.exist?(f) && !File.symlink?(f)
    end
  end
  # return all that are directories or symbolic links
  def self.dir_or_symlink(glob_arg)
    Dir2.globi(glob_arg).select do |f|
      File.symlink?(f) || Dir.exist?(f)
    end
  end
  # fix Dir.pwd, which returns "/cygdrive/c/" instead of "c:/"
  def self.pwd
    Dir.pwd.sub(/\/cygdrive\/([a-z])/,'\1:')
  end
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
  #  "2005-23-10_DEF" => true
  #  "2005-23-XX"     => false
  def self.date_prefix(directory)
    dtp=File.basename(directory)[0..9]
    return nil if ! Date2.valid_date?(dtp)
    Date2.prefix_for_file(dtp)
  end
  # return the union of all the non-directory files found in all the directories passed
  # ex: Dir2.files_in_dirs( [ '.', '.ssh' ] )
  @entries = {}
  def self.files_in_dirs(dir_array, options = {})
    flag = options[:flag]
    return nil if ! validate_dirs_or_symbols(dir_array)
    all_files=[]
    dir_array.each do |d|
      d=File.absolute_path(d)
      d.downcase!
      files = @entries[d]
      if ! files
        print "loading '#{File.basename(d)}'..." if options[:verbose]
        files = @entries[d] = Dir.entries(d)
        puts files.size if options[:verbose]
      end
      files.select! do |f|
        # doesn't seem to work on Mac ???
        #   File.symlink?(f) \
           ! File.symlink?(f) \
        && ! File.directory?(f)
      end
      if all_files.size == 0
        #puts "avoiding .push()..."
        all_files = files
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

  private # private private private private private private private private private

  def self.validate_dirs_or_symbols(dir_array)
    prob_dir = []
    dir_array.each do |d|
      if ! d.instance_of? Symbol
        prob_dir << d if ! Dir.exist? d
      end
    end
    if prob_dir.size > 0
      puts "ERROR: directories do not exist:"
      prob_dir.each do |d|
        puts "  #{d}"
      end
      return nil
    end
    true
  end
end
