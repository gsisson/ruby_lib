require 'spec_helper'
require 'fileutils'
# #require 'fakefs'
# require 'fakefs/safe'
# #require 'fakefs/spec_helpers'
require_relative '../lib/dir2'

describe '#date_time_prefix?' do
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
    @tmp_dir="_tmp_dir_#{rand(10000)}"
    @start_dir=Dir.pwd
    Dir.mkdir(@tmp_dir)
    Dir.chdir(@tmp_dir)
    yield
    Dir.chdir(@start_dir)
    FileUtils.rm_r(@tmp_dir)
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

describe '#glob_i_jpgs' do
  it 'should return jpg and jpeg files' do
    WorkInCleanSubDir.go do
      file_names=%w{file1.jpg File2.jpeg FILE3.bmp}
      just_jpgs =%w{file1.jpg File2.jpeg}
      file_names.each { |fn| FileUtils.touch(fn) }
      expect(Dir2.glob_i_jpgs()).to match_array(just_jpgs)
    end
  end
end
