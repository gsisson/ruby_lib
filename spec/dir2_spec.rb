require 'spec_helper'
require 'fileutils'
# #require 'fakefs'
# require 'fakefs/safe'
# #require 'fakefs/spec_helpers'
require_relative '../lib/dir2'
require_relative '../lib/file_symlink'

describe 'Dir2' do

  describe '#symlink_or_directory?' do
    it 'should return true for a directory' do
      WorkInCleanSubDir.go do
        expect(Dir2.symlink_or_directory?('/')).to be(true)
      end
    end
    it 'should return false for a file' do
      expect(Dir2.symlink_or_directory?(__FILE__)).to be(false)
    end
  end

  describe '#date_time_prefix?' do
    it 'should return true when there is a date-time prefix' do
      expect(Dir2.date_time_prefix?("2005-03-10_23.23.23_DEF")).to eq(true)
    end
    it 'should return false when there is not a date-time prefix' do
      expect(Dir2.date_time_prefix?("2005-03-10_something")).to eq(false)
    end
  end

  describe '#date_time_prefix' do
    it 'should return the date-time prefix, when a valid one is given' do
      expect(Dir2.date_time_prefix("2005-03-10_23.23.23_DEF")).to eq("2005-03-10_23.23.23")
    end
    it 'should return the date-time prefix, even when only the prefix was given' do
      expect(Dir2.date_time_prefix("2005-03-10_23.23.23")).to eq("2005-03-10_23.23.23")
    end
    it 'should return nil if no date-time prefix exists' do
      expect(Dir2.date_time_prefix("c:/users/joe/usr/bin/pc")).to be(nil)
      expect(Dir2.date_time_prefix("/users/joe/usr/bin/pc")).to be(nil)
    end
    it 'should return nil if an invalid date-time prefix is given' do
      expect(Dir2.date_time_prefix("2005-03-10_23.23.2X"))    .to be(nil)
      expect(Dir2.date_time_prefix("2005-23-10"))             .to be(nil)
    end
    it 'should work when a while file-path exists' do
      expect(Dir2.date_time_prefix("c:/users/joe/usr/bin/2005-03-10_23.23.23_ABC")).
        to eq("2005-03-10_23.23.23")
    end
    it 'should not work when a while file-path exists but the date-time is invalid' do
      expect(Dir2.date_time_prefix("c:/users/joe/usr/bin/2005-X3-10_23.23.23_ABC")).to be(nil)
    end
  end
  
  describe '#date_prefix?' do
    it 'should return true when there is a date prefix' do
      expect(Dir2.date_prefix?("2005-03-10_23.23.23_DEF")).to eq(true)
      expect(Dir2.date_prefix?("2005-03-10_some_file")).to    eq(true)
    end
    it 'should return false when there is not a date prefix' do
      expect(Dir2.date_prefix?("2005-03-XX_something")).to eq(false)
      expect(Dir2.date_prefix?("something")).to            eq(false)
    end
  end

  describe '#date_prefix' do
    it 'should return the date prefix, when a valid one is given' do
      expect(Dir2.date_prefix("2005-03-10_xyz"))         .to eq("2005-03-10")
      expect(Dir2.date_prefix("2005-03-10_23.23.23_xyz")).to eq("2005-03-10")
    end
    it 'should return the date prefix, even when only the prefix was given' do
      expect(Dir2.date_prefix("2005-03-10")).to eq("2005-03-10")
    end
  end
  
  class WorkInCleanSubDir
    def self.go()
      begin
        @tmp_dir="_tmp_dir_#{rand(10000)}"
        @start_dir=Dir.pwd
        Dir.mkdir(@tmp_dir)
        Dir.chdir(@tmp_dir)
        yield
      ensure
        Dir.chdir(@start_dir)
        FileUtils.rm_r(@tmp_dir)
      end
    end
  end
  
  # can't use "fakefs: true" here, although I'd like to, because it doesn't emulate
  # the case-sensitive globbing that happens by default on Windows, but not on Mac.
  # So, must create a temp dir and work in it, and clean it up afterwards.
  describe '#glob_i' do
    it 'should return both upper-case, and lower-case files' do
      WorkInCleanSubDir.go do
        file_names=%w{file1 File2 FILE3}
        file_names.each { |fn| FileUtils.touch(fn) }
        expect(Dir2.glob_i('*')).to match_array(file_names)
        if RUBY_PLATFORM =~ /cygwin/
          puts 'testing on windows'
          # on windows, Dir.glob acts in a case-sensitive way, so 'f*' won't match File2 or FILE3
          expect(Dir2.glob_i('f*')).to_not match_array(Dir.glob('f*'))
        else
          puts 'testing on non-windows'
          # on non-windows, Dir.glob acts in a case-INsensitive way, so 'f*' WILL match File2 or FILE3
          expect(Dir2.glob_i('f*')).to match_array(Dir.glob('f*'))
        end
      end
    end
  end
  
  bmp         =%w{FILE.bmp}
  gif         =%w{file.gif}
  jpg         =%w{file.jpg File.jpeg}
  png         =%w{file.png}
  image       = jpg + bmp + gif + png

  cr2         =%w{file4.cr2}
  text        =%w{file.txt}
  movie       =%w{file.avi file.wmv file.mov file.mpg file.mpeg file.mpe}

  file_names  = image + cr2 + text + movie
  jpg_cr2     = jpg + cr2

  describe '#glob_i_jpgs' do
    it 'should return jpg and jpeg files' do
      WorkInCleanSubDir.go do
        expected_files = jpg
        file_names.each { |fn| FileUtils.touch(fn) }
        expect(Dir2.glob_i_jpgs()).to match_array(expected_files)
      end
    end
  end

  describe '#glob_i_jpgs_cr2s' do
    it 'should return jpg, jpeg and cr2 files' do
      WorkInCleanSubDir.go do
        expected_files = jpg_cr2
        file_names.each { |fn| FileUtils.touch(fn) }
        expect(Dir2.glob_i_jpgs_cr2s()).to match_array(expected_files)
      end
    end
  end

  describe '#glob_i_jmages_movies' do
    it 'should return image and movie files' do
      WorkInCleanSubDir.go do
        expected_files = image + movie
        file_names.each { |fn| FileUtils.touch(fn) }
        expect(Dir2.glob_i_images_movies()).to match_array(expected_files)
      end
    end
  end

  describe '#glob_i_images_movies_and_text' do
    it 'should return image, movies, and text files' do
      WorkInCleanSubDir.go do
        expected_files = image + movie + text
        file_names.each { |fn| FileUtils.touch(fn) }
        expect(Dir2.glob_i_images_movies_and_text()).to match_array(expected_files)
      end
    end
  end

  def create_dirs()
    dirs=%w{dir1 dir2 dir3}
    dirs.each do |dir|
      FileUtils.mkdir(dir)
    end
    dirs
  end

  let(:symlinks) {
    {
      'real_file_1' => 'sym_link_file_1',
      'real_file_2' => 'sym_link_file_2',
      'real_file_3' => 'sym_link_file_3',
    }
  }

  def create_symlinks()
    symlinks.keys.each do |file|
      FileUtils.touch(file)
      symlink=symlinks[file]
      File.symlink(file, symlink)
    end
    return symlinks.keys
  end

  describe '#files' do
    it 'should return files, but not include symplinks' do
      WorkInCleanSubDir.go do
        files = create_symlinks()
        expect(Dir2.files('*')).to match_array(files)
      end
    end
  end

  describe '#dir_or_symlink' do
    it 'should return dirs or symlinks, but not regular files' do
      WorkInCleanSubDir.go do
        create_symlinks()
        dirs = create_dirs()
        expect(Dir2.dir_or_symlink('*')).to match_array(symlinks.values+dirs)
      end
    end
  end

  describe '#pwd' do
    it 'on Windows, it should return a directory, starting not with "cygdrive", but with a drive letter' do
      if RUBY_PLATFORM =~ /cygwin/
        WorkInCleanSubDir.go do
          dir_pwd  = Dir.pwd
          dir2_pwd = Dir2.pwd
          expect(dir_pwd) .to      match(%r{/cygdrive/})     # /cygdrive/
          expect(dir_pwd) .to_not  match(%r{^[[:alpha:]]:/}) # c:/
          expect(dir2_pwd).to_not  match(%r{/cygdrive/})     # /cygdrive/
          expect(dir2_pwd).to      match(%r{^[[:alpha:]]:/}) # c:/
        end
      end
    end
  end

end
