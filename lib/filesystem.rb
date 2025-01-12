# input: a list of files including their paths
# dup_name_check() will check that all the basename(file)
# are unique. Will stop with error if two incoming paths
# have the same basename()

require 'open3'
require 'fileutils'
require '~/usr/ruby/lib/dir2.rb'
require '~/usr/ruby/lib/string_colorize.rb'

class FS
  VIDEO_EXTENSIONS = /f4v$|webm$|m2v$|m2t$|flv$|mts$|m4v$|avi$|3gp$|wmv$|mov$|mp4$|mpg$|mpeg$|mkv$/i
  AUDIO_EXTENSIONS = /mp3$/i
  def self.mkshortcut_in_cwd(tgt)
    tgt = tgt.sub("t:/","/cygdrive/t/")
    # puts "in dir: #{Dir.pwd}"
    # puts "  running Open3.popen3('mkshortcut.exe','#{tgt}')"
    _stdin, _stdout, _stderr, wait_thr = Open3.popen3('mkshortcut.exe', "#{tgt}")
    # wait_thr.value.exitstatus # (this will cause a long pause)
  end
  #the -w option to mkshortcut.exe does not work!
  #def self.mkshortcut_over_there(tgt, working_dir)
  #  tgt = tgt.sub("t:/","/cygdrive/t/")
  #  puts "mkshortcut.exe -w #{working_dir} #{tgt}"
  #  _stdin, _stdout, _stderr, wait_thr = Open3.popen3('mkshortcut.exe', "-w #{working_dir}", "#{tgt}")
  #  # wait_thr.value.exitstatus # (this will cause a long pause)
  #end
  def self.all_vids_recursively(dir)
    vids = []
    Dir.chdir dir do
      vids = Dir2.all_files_recursively()
      vids.select! {|i| ! Dir.exist?(i)}
      vids.map! {|i|"#{dir}#{i}"}
      # select only file types interested
      vids.select! {|i| i =~ FS::VIDEO_EXTENSIONS }
      FS.verify_no_dup_files_across_dirs(vids)
    end
    vids
  end
  def self.all_vids_recursively_as_hash(dir)
    vids = self.all_vids_recursively(dir)
    vids_hash = {}
    vids.each do |vid|
      vids_hash[File.basename(vid)] = vid
    end
    vids_hash
  end
  def self.verify_no_dup_files_across_dirs(vids)
    hash = {}
    probs = []
    vids.each do |vid|
      v = File.basename(vid)
      if ! hash[v]
        hash[v] = vid
      else
        probs << vid
      end
    end
    if probs.size > 0
      STDERR.puts("ERROR (in filesystem.rb):".red_bold)
      STDERR.puts("  found dup-named vids:".red_bold)
      probs.each do |prob|
        puts "       #{prob}"
        puts "         #{hash[File.basename(prob)]}"
      end
      STDERR.puts("^^^^^^^^^^^^^^^^^^^^^".red_bold)
      STDERR.puts("ERROR (in filesystem.rb)!".red_bold)
      STDERR.puts("  found dup-named vids!".red_bold)
      exit 1
    end
    hash
  end
  def self.shortcuts_remove_if_exist_in_subdir
    sub_lnks = Dir2.glob_i('**/*.lnk').select { |item| item =~ /\//}
    sub_lnks_hash={}
    sub_lnks.each do |lnk|
      sub_lnks_hash[File.basename(lnk)] = true
    end
    lcl_lnks = Dir2.glob_i('*.lnk')
    lcl_lnks.each do |lnk|
      if sub_lnks_hash[lnk]
        # puts "File.rm #{lnk}"
        FileUtils.rm lnk
      end
    end
  end
end
