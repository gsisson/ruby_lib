class ScriptOptionsParser
  require 'optparse'
  # the user may provide the shortest unambiguous environment
  ENVIRON = %w[dev demo staging production production_standby]
  ENVIRON_ALIASES = { "standby" => "production_standby" }
  def self.usage err_msg=""
    puts "#{err_msg}\n\n" if err_msg
    puts (parse ['--help'])
    abort
  end
  def self.parse(args)
    options = {}
    options[:proxy]=ENV['http_proxy']||ENV['HTTP_PROXY']||ENV['https_proxy']||ENV['HTTPS_PROXY']
    parser = OptionParser.new do |opts|
      opts.set_summary_width 24
      opts.banner = "Usage: #{File.basename(__FILE__)} [options]"
      opts.separator ""
      opts.separator "  options:"
      code_list = (ENVIRON_ALIASES.keys + ENVIRON).join(',')
      opts.on('-e', '--env RAILS_ENV', ENVIRON, ENVIRON_ALIASES, 'Select rails environment:',
              "  (#{code_list})") do |e|
        options[:env] = e
      end
#     opts.on('-d','--delay N', Integer, 'Delay N seconds before executing') do |n|
#       options[:delay] = n
#     end
#     # Optional argument; multi-line description.
#     opts.on("-i", "--inplace [EXTENSION]", "Edit ARGV files in place",
#             "  (make backup if EXTENSION supplied)") do |ext|
#       options = OpenStruct.new # require 'ostruct'
#       options.inplace = true
#       options.extension = ext || ''
#       options.extension.sub!(/\A\.?(?=.)/, ".")  # Ensure extension begins with dot.
#     end
      opts.on_tail('--noproxy','Ignore any proxy variables in the environment') do |flag|
        ENV['http_proxy' ] = nil
        ENV['HTTP_PROXY' ] = nil
        ENV['https_proxy'] = nil
        ENV['HTTPS_PROXY'] = nil
        options[:proxy] = nil
      end
      opts.on_tail("-h", "--help", "Show this usage message") do
        puts opts.help
        abort
      end
    end
    parser.parse! args
    usage "ERROR: Rails environment must be specified!" unless options[:env]
    return options
  end
end

begin
  options = ScriptOptionsParser.parse(ARGV)
  puts "# DEBUG: options found:  #{options}"
  puts "# DEBUG: args left over: #{ARGV}"
rescue OptionParser::ParseError => e
  puts ScriptOptionsParser.usage "ERROR: #{e.message.split.map(&:capitalize).join(' ')}"
rescue SystemExit => e
  raise # re-raising passes the correct return code to the shell
rescue Interrupt => e
  puts "\nCancelled by user."
rescue Exception => e
  puts "ERROR: Unexpected Exception:"
  puts "       (#{e.class}) #{e.message}"
  puts "       backtrace: "
  rubypath=""
  e.backtrace.each do |i|
    if i =~ /.*\/ruby\//
      rubypath=i.sub( i.sub( /.*\/ruby/, "" ), "" )
      puts "         ruby=\"#{rubypath}\""
    break
    end
  end
  e.backtrace.each do |i|
    i2=i.sub( rubypath, "" )
    if i != i2
      i.sub!( rubypath, '${ruby}' )
    end
    puts "         #{i}"
  end
  abort
end
