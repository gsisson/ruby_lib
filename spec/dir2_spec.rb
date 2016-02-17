require 'rspec'
require 'spec_helper'
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

describe '#globi', fakefs: true do
  it 'On Windows, should return both upper-case, and lower-case files' do
    dir='sub_dir'
    Dir.mkdir(dir)
    Dir.chdir(dir)
    file_names=%w{file1 File2 FILE3}
    file_names.each do |fn|
      File.open(fn,'w') { |f|f.puts(fn) }
    end
    expect(Dir2.globi('*')).to match_array(file_names)
    if RUBY_PLATFORM =~ /cygwin/
      puts 'testing on windows'
      expect(Dir2.globi('*')).to_not match_array(Dir.glob('*'))
    else
      puts 'testing on non-windows'
      expect(Dir2.globi('*')).to     match_array(Dir.glob('*'))
    end
  end
end
