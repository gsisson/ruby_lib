#!/usr/bin/env ruby

require '~/usr/ruby/lib/dir2.rb'
require '~/usr/ruby/lib/string_colorize.rb'
#require '~/usr/ruby/lib/file_symlink'
require '~/usr/ruby/lib/filesystem'
require 'clipboard' #gem install clipboard
#require 'open3'

DIR ='t:/RECYCLABLE/v/'

#video_extentions_ok = /lnk$|mp3$|jpg$|jpeg$|txt$|xmp$|png$|sh$|proj$|gif$|url$|tif$|rb$|THM$|AAE$|psd$/i
 video_extentions_ok = /f4v$|webm$|m2v$|m2t$|flv$|mts$|m4v$|avi$|3gp$|wmv$|mov$|mp4$|mpg$|mpeg$|mkv$/i

def usage(args = nil)
  name = File.basename(__FILE__)
  STDERR.puts("\n#{args}\n\n") if args != nil
  STDERR.puts "usage: #{name}"
  exit 1
end

if ! Dir.exist?(DIR)
  STDERR.puts "Directory DNE! #{DIR}"
  exit 1
end

usage("ERROR: arguments unexpected") if ARGV.count != 0

Dir.chdir DIR

STDERR.print "# looking up all files..."
vids = Dir2.all_files_recursively()
vids.select! {|i| ! Dir.exist?(i)}
STDERR.puts " found #{vids.count} files"

STDERR.print "# extracting just .lnk files..."
links = vids.select { |vid| vid =~ /lnk$/ }
STDERR.puts " found #{links.count} lnks"

STDERR.print '# extracting just vids...'
vids.select! {|i| i =~ video_extentions_ok } # reject files of types not interested in
STDERR.puts " found #{vids.count} vids"

vids.map! {|i|"#{DIR}#{i}"}
STDERR.print '# checking for duplicate vids...'
hash = FS.verify_no_dup_files_across_dirs(vids)
STDERR.puts " ok"
STDERR.print '# checking for lnks with no vids...'
h_miss_all = {}
links.each do |link|
  bnlnk=File.basename(link)
  bn=bnlnk.sub(/.lnk$/,'')
  if bn =~ video_extentions_ok
    if hash[bn] == nil
      if h_miss_all[bnlnk] == nil
        # STDERR.puts "h_miss_all['#{bnlnk}'] = ['#{link}']"
        h_miss_all[bnlnk] = [link]
      else
        # STDERR.puts "h_miss_all['#{bnlnk}'] << '#{link}'"
        h_miss_all[bnlnk] << link
      end
    end
  end
end

h_miss = h_miss_all.keys
if h_miss.count == 0
  puts
else
  h_miss.each do | miss |
    STDERR.puts "================="
    STDERR.puts miss.yellow
    h_miss_all[miss].each do |full|
      STDERR.print "#{DIR}#{File.dirname(full)}/"
      STDERR.puts File.basename(full).cyan
    end
  end
end
