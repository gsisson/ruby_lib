require 'spec_helper'
require 'fileutils'
require_relative '../lib/file_symlink'
require_relative '../helpers/work_in_clean_subdir'

describe 'File' do

  describe '#symlink' do
    it 'should call Open3 to run "cmd.exe", and not call the original #symlink' do
      expect(Open3).to receive(:popen3).with('cmd.exe')
      expect(File).to_not receive(:old_symlink)
      WorkInCleanSubdir.go do
        File.symlink('/', 'root')
      end
    end
  end

  describe '#symlink?' do
    it 'should call Open3 to run "cmd.exe", and not call the original #symlink?' do
      expect(Open3).to receive(:popen3).with('cmd.exe')
      expect(File).to_not receive(:old_symlink?)
      WorkInCleanSubdir.go do
        File.symlink?('/')
      end
    end
  end

  describe '#symlink_windows?' do
    it 'return false on Windows' do
      expect(File.symlink_windows?('/')).to be(false)
    end
  end

end
