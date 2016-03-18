require 'spec_helper'
require 'fileutils'
require_relative '../lib/pathname2'

describe 'Pathname' do

  describe '#cygwin_to_dos' do
    it 'should do nothing if not cygwin path' do
      [
       'c:\users\someone\dir\file',
       'c:/users/someone/dir/file',
       'c:/users/someone/cygdrive/file',
       ''
      ].each do |path|
        expect(Pathname.cygwin_to_dos(path)).to eq(path)
      end
    end
    it 'should convert for cygwin paths' do
      expect(Pathname.cygwin_to_dos('/cygdrive/c/users/someone/dir/file')).to eq('c:/users/someone/dir/file')
      expect(Pathname.cygwin_to_dos('/cygdrive/x/tmp/')).to eq('x:/tmp/')
    end
  end

  describe '#tildize' do
    it 'should do nothing if not in a home directory path' do
      ENV['HOME']='/Users/joe'
      [
       '\users\someone\dir\file',
       '/users/someone/dir/file',
       '/users/someone/cygdrive/file',
       '/cygdrive/d/users/joe/dir/file',
       '/cygdrive/x/file',
       ''
      ].each do |path|
        expect(Pathname.tildize(path)).to eq(path)
      end
      ENV['HOME']='/Users/joe'
      [
       '\users\someone\dir\file',
      ].each do |path|
        expect(Pathname.tildize(path)).to eq(path)
      end
    end
    require_relative './pathname2_spec_WIN.rb' if RUBY_PLATFORM =~ /mswin32|cygwin|mingw|bccwin/
  end

end
