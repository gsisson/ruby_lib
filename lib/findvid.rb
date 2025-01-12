#!/usr/bin/env ruby

require '~/usr/ruby/lib/dir2.rb'
require '~/usr/ruby/lib/file_symlink'
require '~/usr/ruby/lib/string_colorize.rb'
require 'clipboard' #gem install clipboard

class FindVid
  DIR ='t:/RECYCLABLE/v/'
  DIR2='t:/Premiere.Pro.Work/'
  def self.usage(args = nil)
    name = File.basename(__FILE__)
    STDERR.puts("\n#{args}\n\n") if args != nil
    STDERR.puts "usage: #{name} -"
    STDERR.puts "   or: #{name} -n"
    STDERR.puts "   or: #{name} -v # vid"
    STDERR.puts "   or: #{name} -l # lnk"
    STDERR.puts "   or: #{name} UID"
    STDERR.puts "   or: #{name} <SEARCH_STRING>..."
    STDERR.puts "       -   clipboard will hold a string to look for"
    STDERR.puts "       -n  clipboard will hold a uid-prefix string, and only the uid will be searched for"
    exit 1
  end
  def self.matchit(i,arg)
    i = File.basename(i) # get rid of path, as we don't want to be matching in the path!
    value = i =~ %r{[^a-zA-Z]#{arg}[^a-zA-Z/]}i || i =~ %r{[^a-zA-Z]#{arg}$}i || i =~ %r{^#{arg}[^a-zA-Z/]}i || i =~ %r{^#{arg}$}i
    #if ( i =~ /0000.dress/ )
    #  ['.00','.30','.50','.60','.72','.75'].each do |j|
    #    i_test = i.sub("0000.dress#{j}",'')
    #    value = value && i_test =~ %r{[^a-zA-Z]#{arg}[^a-zA-Z/]}i
    #  end
    #end
    value != nil
  end
  def self.cleann(n)
    # examples that return '665572'
    # examples that return '665572'
    # puts cleann('_5_#048585#abcd.txt')
    # puts cleann('#665572#some.name.mp4')
    # puts cleann('#665572#')
    # puts cleann('#665572')
    # puts cleann('#####665572')
    # puts cleann('665572')
    # STDERR.puts "cleann(#{n})"
    # STDERR.puts "  #{n}"
    n=n.sub(/##*/,'#')
    # STDERR.puts "a #{n}"
    n=n.sub('#FAV#','#')
    # STDERR.puts "b #{n}"
    n=n.sub(/#[0-9][0-9][0-9]bpm#/,'#')
    # STDERR.puts "c #{n}"
    n=n.sub(/^[^#]*/,'') if n =~ /#.*#/ # throw out chars before the first hash
    # STDERR.puts "d #{n}"
    n=n.sub(/[^#]*$/,'') if n =~ /#.*#/ # throw out chars after the last hash
    # STDERR.puts "e #{n}"
    n=n.sub(/^#*/,'')
    # STDERR.puts "f #{n}"
    n=n.sub(/#*$/,'')
    # STDERR.puts "g #{n}"
    if n !~ /[0-9][0-9][0-9][0-9][0-9][0-9]/
      abort "ERROR: '#{n}' is not a 6 digit number!"
    end
    # STDERR.puts "  #{n}<--"
    n
  end
  def self.main(arguments)
    if ! Dir.exist?(DIR)
      STDERR.puts "Directory DNE! #{DIR}"
      exit 1
    end
    if arguments.size == 0
      usage
    end
    no_lnks = false
    only_lnks = false
    arguments.each_with_index do |arg, i|
      if arg == '-v'
        no_lnks = true
        arguments.delete_at(i)
        break
      end
      if arg == '-l'
        only_lnks = true
        arguments.delete_at(i)
        break
      end
    end
    if no_lnks && only_lnks
      usage "ERROR: cannot use -v and +v together"
    end
    arguments.each_with_index do |arg, i|
      if arg == '-'
        n=Clipboard.paste.split
        usage "ERROR: clipboard contains more than one line!" if n.size != 1
        arguments[i]=n[0]
        break
      end
    end
    arguments.each_with_index do |arg, i|
      if arg =~ /^#?[0-9][0-9][0-9][0-9][0-9][0-9]#?$/
        STDERR.puts arg
        n = cleann(arg)
        if n.size == 0
          STDERR.puts "INTERNAL ERROR: cleaned up a number and got an empty string??"
          exit 1
        end
        arguments[i] = n
      end
    end
    items = arguments
   #STDERR.puts "===================================================="
   #STDERR.puts "searching:"
    STDERR.print "searching: "
    items.each { |i| STDERR.print "#{i} ".cyan_bold }
    STDERR.puts
   #STDERR.puts "=========================="
    curdir=Dir2.pwd
    curdir="#{curdir}/" if curdir =~ /^[a-z]:$/
    
    files = files2 = nil
    Dir.chdir(DIR) do
      files = Dir2.all_files_recursively()
      files.map! {|i|"#{DIR}#{i}"}
    end
    Dir.chdir(DIR2) # can't use Dir.chdir block here, as Dir2.files() also uses a block :-(
    files2 = Dir2.files("*") # Dir2.files('#*')
    Dir.chdir(curdir)
    files2.map! {|i|"#{DIR2}#{i}"}
    files += files2
    
    #files.select! { |i| i !~ /^#{curdir}/i } # reject ones (dir problem) in/under the directory this is run from
    
    test_special_case = false
    if test_special_case
      items = []
      files = []
    end
    
    #STDERR.puts "#{files.length}"
    # reject files of types not interested in
    if only_lnks
      re=/lnk$/i
      files.select! {|i| i =~ re }
    else
      if no_lnks
        re=/aae$|jpeg$|txt$|xmp$|png$|sh$|prproj$|lnk$/i
      else
        re=  /aae$|jpg$|jpeg$|txt$|xmp$|png$|sh$|prproj$/i
      end
      files.select! {|i| i !~ re }
    end
    #STDERR.puts "#{files.length}"
    
    items.each do |arg|
      #puts files.length
      #STDERR.puts "-> #{files.length}"
      #STDERR.puts "--> #{files[0]}"
      files.select! do |i|
        #puts "matchit(#{i},#{arg})"
        matchit(i,arg.sub('(','\(').sub(')','\)').sub('^','\^').sub('+','\+'))
      end
      #STDERR.puts "-> #{files.length}"
      #STDERR.puts "--> #{files[0]}"
    end
    #STDERR.puts "#{files.length}"
    return files
  end
end
