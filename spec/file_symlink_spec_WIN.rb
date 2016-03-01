require 'spec_helper'
require 'fileutils'
require_relative '../lib/file_symlink'
require_relative '../helpers/work_in_clean_subdir'

describe 'File' do

  describe '#symlink' do
    it 'should call Open3 to run "cmd.exe", and not call the original #symlink' do
      # rather than run this line:
      #   expect(Open3).to receive(:popen3).with('cmd.exe','/c mklink /d users \\users')
      # which breaks the #symlink method (since open is not called, so there is no thread
      # to wait on), just verify that the file system really gets a symlink created.
      expect(File).to_not receive(:old_symlink)
      WorkInCleanSubdir.go do
        # ls -l should return:
        # "total 0"
        # "with no listing for /users linking to /cygdrive"
        expect(`ls -l`).to_not match(/users -> \/cygdrive/)
        File.symlink('/users', 'users')
        # ls -l should return something like:
        # "total 0"
        # "lrwxrwxrwx 1 user group 17 Feb 29 22:34 users -> /cygdrive/c/users"
        expect(`ls -l`).to     match(/users -> \/cygdrive/)
      end
    end
  end

  describe '#symlink?' do
    it 'should call Open3 to run "cmd.exe", and not call the original #symlink?' do
      WorkInCleanSubdir.go do
        expect(File.symlink?('/users')).to be(false)
        expect(File.symlink?( 'users')).to be(false)
        File.symlink('/users', 'users')
        expect(File.symlink?('/users')).to be(false)
        expect(File.symlink?( 'users')).to be(true)
      end
    end
  end

  describe '#symlink_windows?' do
    it 'return false on Windows' do
      expect(File.symlink_windows?('/')).to be(false)
    end
  end

end
