require 'timeout'

require_relative 'string_colorize.rb'

class Net

  PROXY_RE = /^15./
  @wifi_info     = nil
  @ether_info    = nil
  @network_order = nil
  @networks      = nil
  @verbose       = false
  PROXY_VARS=%w{http_proxy https_proxy HTTP_PROXY HTTPS_PROXY ALL_PROXY}

  def toggle()
    ether = get_info(:ether)
    wifi  = get_info(:wifi)

    preferred_network = :ether
    if    ether[:enabled] && ether[:connected] \
       &&  wifi[:enabled] && wifi[:network]
      puts "# Both networks are enabled."
      puts "# Switching to '#{preferred_network}'..."
      network_to_turn_off = preferred_network == :ether ? :wifi : :ether
      puts turn_off(network_to_turn_off)
      return
    end
    if !ether[:enabled] && !wifi[:enabled]
      puts "# Neither network is enabled."
      puts "# Switching to '#{preferred_network}'..."
      turn_on(preferred_network)
      return
    end
    new_network = ether[:enabled] ? :wifi  : :ether
    puts "# Switching to #{new_network}"
    switch_to(new_network)
  end

  def details(network)
    msg = []
    info = get_info(network)
    msg << "# "+"Current status of #{info[:name]} network:".YELLOW
    info.keys.sort.each do |key|
      the_key=key
      if %w{enabled network connected}.include?(key.to_s)
        if info[key]
          the_key="#{key}".GREEN
        else
          the_key="#{key}".RED
        end
      end
      msg << "#   #{the_key}: #{info[key]}"
    end
    msg.join("\n")
  end

  def status(network = nil)
    msg = []
    if ! network
      msg << "# Network status, in priority order:"
      order[:order].each do |item|
        msg << status(item)
      end
      msg << network_violation_msg() if network_violation?
      return msg.join("\n") if msg
    end
    status    = ""
    connected = nil
    info      = get_info(network)
    case network
    when :ether
      connected = info[:connected]
    when :wifi
      connected = info[:network]
    end
    status += "#   "
    if info[:enabled] && connected
      status += "#{info[:name]}".GREEN
    else
      status += "#{info[:name]}".RED
    end
    status += ": "
    status += (info[:enabled] ? "enabled".GREEN : "disabled".RED)
    case network
    when :ether
      status += (connected ? ", connected".GREEN : ", "+"disconnected".RED) if info[:enabled]
    when :wifi
      status += (connected ? ", network: #{info[:network].GREEN}" : '')
    end
    status += " (ip: #{info[:ip]})" if info[:enabled]
    return status
  end

  def proxy_query()
    if PROXY_VARS.any? { |var| ENV[var] }
      return "# proxy env vars ARE set"
    else
      return "# proxy env vars are NOT set"
    end
  end

  def proxy_set()
    ether = get_info(:ether)
    wifi  = get_info(:wifi)

    proxy_vars_should_be_on = network_requires_proxy?()
    proxy_vars_are_on = PROXY_VARS.any? { |var| ENV[var] }

    msg = []
    proxy_msg = ""
    if proxy_vars_should_be_on
      proxy="web-proxy:8088"
      proxy_file=ENV['HOME']+'/.proxy'
      if File.exist?(proxy_file)
        proxy=File.read(proxy_file).chomp
        proxy_msg += "# (note: using proxy server/port found in ~/.proxy)"
        proxy=proxy.sub(%r{https:/},'')
        proxy=proxy.sub(%r{http:/},'')
      else
        proxy_msg += "# using default proxy server/port (override file ~/.proxy not found)"
      end
      PROXY_VARS.each do |var|
        protocol = ( var =~ /https/i ) ? 'https' : 'http'
        msg << "export #{var}=#{protocol}://#{proxy};" unless ENV[var]
      end
      unless msg.empty?
        msg << "# proxy vars should be set!"
        msg << "# set them with: \"eval $(#{THIS_FILE} proxy)\""
        msg << proxy_msg
      end
    else
      # build the command to unset any HTTP PROXY vars
      proxy_vars=""
      PROXY_VARS.each do |var|
        proxy_vars += "#{var} " if ENV[var]
      end
      unless proxy_vars.empty?
        msg << "# proxy vars should not be set"
        msg << "# unset them with: \"eval $(#{THIS_FILE} proxy)\""
        msg <<  "unset #{proxy_vars};"
      end
    end
    if msg.empty?
      status = proxy_vars_should_be_on ? "(they are set)" : "(they are not set)"
      return "# proxy vars are set correctly #{status}"
    end
    return msg.join("\n")
  end

  def turn_off(network)
    msg = []
    msg << "#   Turning off #{network_name_human(network)}"
    case network
    when :ether
      ether = get_info(:ether)
      if ether[:enabled]
        cmd="networksetup -setnetworkserviceenabled '#{ether[:name]}' off"
        msg << "# + #{cmd}" if verbose?
        status = `#{cmd}`
        msg << status unless status.empty?
        if $?.exitstatus != 0
          msg << "ERROR turning off #{network_name_human(network)}!".RED
          return msg.join("\n")
        end
        refresh_network_info()
      end
    when :wifi
      wifi = get_info(:wifi)
      if wifi[:enabled]
        cmd="networksetup -setairportpower '#{wifi[:device]}' off"
        msg << "# + #{cmd}" if verbose?
        status = `#{cmd}`
        msg << status unless status.empty?
        if $?.exitstatus != 0
          msg << "ERROR turning off #{network_name_human(network)}!".RED
          return msg.join("\n")
        end
        refresh_network_info()
      end
    end
    return msg.join("\n")    
  end

  def turn_on(network)
    puts "#   Turning on #{network_name_human(network)}"
    case network
    when :ether
      turn_on_ether()
    when :wifi
      turn_on_wifi()
    else
      abort "ERROR: unrecognized network requested: '#{network}'"
    end
    puts network_violation_msg() if network_violation?
  end

  ################################################################################

  private

  def turn_on_ether()
    ether = get_info(:ether)
    wifi  = get_info(:wifi)

      if ether[:enabled]
        print "#     "+"Ethernet is already on".GREEN
        if ether[:connected]
          puts
        else
          puts " (but "+"there is no connection... check the network cable".YELLOW+")"
        end
        return
      end
      cmd="networksetup -setnetworkserviceenabled '#{ether[:name]}' on"
      puts "# + #{cmd}" if verbose?
      #status = `#{cmd}`
      system "#{cmd}"

      ether  = get_info(:ether, refresh: true)
      if ether[:enabled]
        seconds_to_wait=10
        begin
          wait_time = seconds_to_wait
          status = Timeout::timeout(seconds_to_wait) do
            print "#     Ethernet now " + "enabled".GREEN
            if ether[:connected]
              puts " and "+"connected".GREEN
              break
            end
            print ", waiting for connection..."
            puts if verbose?
            while true do
              print " #{wait_time}" if wait_time != seconds_to_wait
              wait_time -= 1
              sleep 1
              ether  = get_info(:ether, refresh: true)
              if ether[:connected]
                puts
                puts "#       now connected (ip: #{ether[:ip].GREEN})"
                break
              end
            end
          end
        rescue Timeout::Error
          puts # to get on a new line
          puts "#     "+"WARNING: No connection!  Check the network cable. (or give it more time)".YELLOW
        end
      else
        puts "ethernet is " + "disabled".RED
      end
  end

  def turn_on_wifi()
    ether = get_info(:ether)
    wifi  = get_info(:wifi)

      if wifi[:enabled]
        print "#     "+"Wi-fi is already on".GREEN
        if wifi[:network]
          puts " (and connected to '#{wifi[:network].GREEN}')"
        else
          puts " (but "+"not connected".RED+" to any network)"
        end
        return
      end

      cmd="networksetup -setairportpower '#{wifi[:device]}' on"
      puts "# + #{cmd}" if verbose?
      status=`#{cmd}`
      wifi  = get_info(:wifi, refresh: true)
      if wifi[:enabled]
        seconds_to_wait=5
        begin
          wait_time = seconds_to_wait
          status = Timeout::timeout(seconds_to_wait) do
            print "#     wi-fi now " + "enabled".GREEN
            if wifi[:network]
              puts " and connected (to '#{wifi[:network].GREEN}')"
              break
            end
            print ", waiting for network..."
            puts if verbose?
            while true do
              print " #{wait_time}" if wait_time != seconds_to_wait
              wait_time -= 1
              sleep 1
              wifi  = get_info(:wifi, refresh: true)
              if wifi[:network]
                puts
                puts "#       now connected to '#{wifi[:network].GREEN}'"
                break
              end
            end
          end
        rescue Timeout::Error
          puts # to get on a new line
          puts "#     "+"WARNING: No network has yet been joined!".YELLOW
          puts "#     "+"         You may need to manually select a wi-fi network. (or wait longer)"
        end
      else
        puts "wi-fi is " + "disabled".RED
      end
  end

  def refresh_network_info()
    @wifi_info     = nil
    @ether_info    = nil
    @network_order = nil
    @networks      = nil
  end

  def verbose(flag)
    @verbose = flag
  end

  def verbose?
    @verbose
  end

  def ether_requires_proxy?()
    ether = get_info(:ether)
    ether[:ip] && ! ether[:ip].match(PROXY_RE).nil?
  end
  
  def wifi_requires_proxy?()
    wifi = get_info(:wifi)
    wifi[:ip] && ! wifi[:ip].match(PROXY_RE).nil?
  end
  
  def network_requires_proxy?()
    ether = get_info(:ether)
    wifi  = get_info(:wifi)
    return wifi_requires_proxy?()  if order[:first] == :wifi  &&   wifi[:enabled]
    return ether_requires_proxy?() if order[:first] == :ether &&   ether[:enabled]
    return ether_requires_proxy?() if order[:first] == :wifi  && ! wifi[:enabled]
    return wifi_requires_proxy?()  if order[:first] == :ether && ! ether[:enabled]
  end

  def mixed_network?()
    # true if both networks are enabled, but only one requires a proxy
    ether = get_info(:ether)
    wifi  = get_info(:wifi)
    return false unless wifi[:enabled] && ether[:enabled]
    return ether_requires_proxy?() ^ wifi_requires_proxy?() # xor
  end
  
  def switch_to(network)
    joining_network = network
    leaving_network = ( network == :ether ) ? :wifi : :ether
    result = turn_off(leaving_network)
    puts result
    return if result =~ /error/i
    turn_on(joining_network)
  end

  def network_name_human(network)
    case network
    when :wifi
      "wi-fi"
    when :ether
      "ethernet"
    end
  end

  def network_violation?()
    network_violation_msg() != nil
  end

  def network_violation_msg()
    ether = get_info(:ether)
    wifi  = get_info(:wifi)

    # check if we are on both a proxied network and a non-proxied network
    msg = []
    if mixed_network?
      proxy_network_in_use = ether_requires_proxy? ? 'ethernet' : 'wifi'
      other_network_in_use = ether_requires_proxy? ? 'wifi'     : 'ethernet'
      msg << "# "+"WARNING: Proxied network is enabled (#{proxy_network_in_use}), but so is a non-proxied network (#{other_network_in_use})!".YELLOW
      msg << "# "+"         This can be a security risk.".YELLOW
      msg << "# "+"         You should turn off one of the networks.".YELLOW
      return msg.join("\n")
    end
    nil
  end

  def get_info(network, options = {})
    refresh_network_info() if options[:refresh]
    case network
    when :wifi
      return @wifi_info if @wifi_info
      XXget_wifi_info()
    when :ether
      return @ether_info if @ether_info
      XXget_ether_info()
    end
  end

  def XXget_wifi_info(options = {})
    refresh_network_info() if options[:refresh]
    return @wifi_info if @wifi_info

    # Get device id, and whether enabled
    @wifi_info = networks()[:wifi]
    @wifi_info[:enabled] = nil
    cmd="networksetup -getairportpower '#{@wifi_info[:device]}'"
    puts "# + #{cmd}" if verbose?
    full_status = `#{cmd}`
    if $?.exitstatus == 0
      # we'll extract the device and on/off status from a string like this
      #   "Wi-Fi Power (en0): On"
      #                 ^^^   ^^
      not_used, device, enabled = full_status.match(/.*\((.*)\).* (.*)/).to_a
      enabled = (enabled =~ /on/i ) ? true : false
      @wifi_info[:enabled] = enabled
    end

    # Get name of wireless network
    cmd = "networksetup -getairportnetwork '#{@wifi_info[:device]}'"
    puts "# + #{cmd}" if verbose?
    full_status = `#{cmd}`
    if $?.exitstatus == 0
      # we'll extract the name of the connected wifi network
      #   "Current Wi-Fi Network: mobile-rdwlan"
      #                           ^^^^^^^^^^^^^
      match = full_status.match(/Current Wi-Fi Network: (.*)/)
      network = ( match && match[1] ) ? match[1] : nil
      @wifi_info[:network] = network
    end

    # Get IP address
    cmd = "networksetup -getinfo '#{@wifi_info[:name]}'"
    puts "# + #{cmd}" if verbose?
    full_status = `#{cmd}`.split("\n")
    # Here is what we are looking for in the 'networksetup -getinfo ' output:
    #
    # IP address: 192.168.0.105
    #             ^^^^^^^^^^^^^ enabled, and connected
    #                           (line missing when 'disabled', or while 'coming up')
    full_status.each do |line|
      if matches = line.match(/^IP address: (.*)/)
        @wifi_info[:ip] = matches[1]
      end
    end
    @wifi_info
  end

  def XXget_ether_info(options = {})
    refresh_network_info() if options[:refresh]
    return @ether_info if @ether_info

    @ether_info = networks()[:ether]
    @ether_info[:connected] = false
    @ether_info[:enabled]   = true
    cmd = "networksetup -getinfo '#{@ether_info[:name]}'"
    puts "# + #{cmd}" if verbose?
    full_status = `#{cmd}`.split("\n")
    # Here is what we are looking for in the 'networksetup -getinfo ' output:
    #
    # IP address: 192.168.0.105
    #             ^^^^^^^^^^^^^ enabled, and connected
    #                           (line missing when 'disabled', or while 'coming up')
    #
    # (Please note: Thunderbolt Ethernet is currently disabled)
    #                                                 ^^^^^^^^ disabled
    #                                                          (line missing when 'enabled')
    full_status.each do |line|
      @ether_info[:connected] = true  if line.match(/^IP address/)
      @ether_info[:enabled]   = false if line.match(/disabled/)
      if matches = line.match(/^IP address: (.*)/)
        @ether_info[:connected] = true
        @ether_info[:ip] = matches[1]
      end
    end
    @ether_info
  end

  def networks()
    @networks || load_network_info()
    @networks
  end

  def order()
    @network_order || load_network_info()
    @network_order
  end
  
  def load_network_info()
    @network_order = nil
    @networks      = nil
    # Consumes the output of the "networksetup -listnetworkserviceorder"
    # and loads information about the order of the wifi network and ethernet network.
    # Also loads other network details of interest.
    #
    # Example, if "networksetup -listnetworkserviceorder" generates:
    #
    # | An asterisk (*) denotes that a network service is disabled.
    # | 
    # | (1) Wi-Fi
    # | (Hardware Port: Wi-Fi, Device: en0)
    # | 
    # | (*) Thunderbolt Ethernet
    # | (Hardware Port: Thunderbolt Ethernet, Device: en4)
    # | 
    # | (2) Display Ethernet
    # | (Hardware Port: Display Ethernet, Device: en6)
    # | 
    # | (3) Ethernet 1
    # | (Hardware Port: Ethernet 1, Device: en8)
    #
    # Then this method would set @networks to be the hash:
    #   { :wifi  => { :name => 'wi-fi',                :device => 'en0' },
    #     :ether => { :name => 'thunderbolt ethernet', :device => 'en4' }  }
    #
    # And would set @network_order to be the hash:
    #   { :first  => :wifi,
    #     :second => :ether' }
    #
    # On the other hand, if 'Ethernet 1' was the higher priority ethernet (higher in
    # the list), then @network_order to be the hash:
    #
    #   { :first  => :ether,
    #     :second => :wifi   }
    #
    
    # collect the full list of networks, in order
    @network_order = {} # []
    @networks      = {}
    wifi_hash  = {}
    ether_hash = {}
    current_network=nil
    cmd = "networksetup -listnetworkserviceorder"
    puts "# + #{cmd}" if verbose?
    ordered_network_info = `#{cmd}`.split("\n")
    ordered_network_info.each do |line|
      # stop when our array has two entries (wifi and ether) and each has
      # two keys (name and device)
      if @networks.keys.size == 2
        if @networks.keys.all? { |key| @networks[key].size == 2 }
          @network_order[:order] = [@network_order[:first], @network_order[:second]]
          break
        end
      end
      # skip blank lines
      line.chomp!
      next if line.size == 0
      # skip the line mentioning what an asterisk means
      next if line.match(/^An asterisk.*/)
      # handle lines naming an interface
      if line =~ /^\([0-9*]+\) /
        line = line.sub(/^\([0-9*]+\) /,'')
        case 
        when line.match(/Wi-Fi/i)
          tag=:wifi
          current_network=wifi_hash
        when line.match(/Ethernet/i)
          tag=:ether
          current_network=ether_hash
        else
          next
        end
        current_network[:name] = line
        @networks[tag] = current_network
        @network_order[:second] = tag if  @network_order[:first]
        @network_order[:first]  = tag if !@network_order[:first]
        next
      end
      if line =~ /^\(.*\)$/
        matches = line.match(/^.* (.*)\)$/)
        current_network[:device] = matches[1]
      end
    end
  end
end
