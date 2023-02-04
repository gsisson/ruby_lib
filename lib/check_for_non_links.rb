#!/usr/bin/env ruby

require '~/usr/ruby/lib/dir2.rb'

def check_for_nonlinks(dir, regex)
  the = "#{dir}_QUICK/"
  if ! Dir.exist?(the)
    STDERR.puts "Directory DNE! #{the}"
    exit 1
  end
  Dir.chdir the do
    items = Dir2.glob_i('**/*')
    items.select! do |item|
      # not a directory, and not an allowed file
      ! Dir.exist?(item) && item !~ regex
    end
    if items.size > 0
      STDERR.puts
      STDERR.puts "SHORTCUT ERROR!!"
      STDERR.puts "Found non .lnk files under #{the}:"
      STDERR.puts
      items.each do |item|
        STDERR.puts "#{the}#{item}"
      end
      STDERR.puts
      exit 1
    end
  end
end
