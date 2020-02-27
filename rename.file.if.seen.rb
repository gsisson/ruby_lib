#!/usr/bin/env ruby

require 'fileutils'

file_target="file1.dat"
file_source="#{file_target}.tmp"

puts "watching for file (#{file_source})..."
loop do
  if File.file? file_source
    puts "  found!"
    if File.file? file_target
      puts "  Warning! Cannot rename, as the target file exists! (#{file_target})"
    else
      print "  renaming (#{file_source} to #{file_target})..."
      begin
        FileUtils.mv file_source, file_target
        puts " success!"
      rescue Exception => ex
        puts " ERROR! (#{ex.message})"
      end
    end
    puts "resuming watch for file (#{file_source})..."
  end
  sleep 1 # second
  puts "watching for file (#{file_source})..."
end
