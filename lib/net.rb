require 'timeout'

require_relative 'string_colorize.rb'

class Net
  DEFAULT_PROXY="web-proxy"
  DEFAULT_PROXY_PORT="8088"
  PROXY_OVERRIDE_FILE="#{ENV['HOME']}/.proxy"
  PROXY_RE = /^15./
  @wifi_info     = nil
  @ether_info    = nil
  @network_order = nil
  @networks      = nil
  @verbose       = false
  @@indent       = ""
  PROXY_VARS=%w{http_proxy https_proxy HTTP_PROXY HTTPS_PROXY ALL_PROXY}

  def toggle();              indenter { toggle_private()         } end
  def details(network);      indenter { details_private(network) } end
  def status(network = nil); indenter { status_private(network)  } end
  def proxy_query();         indenter { proxy_query_private()    } end
  def proxy_set();           indenter { proxy_set_private()      } end
  def turn_off(network);     indenter { turn_off_private(network)} end
  def turn_on(network);      indenter { turn_on_private(network) } end

  def verbose(flag)
    @verbose = flag
  end

  def verbose?
    @verbose
  end

  ################################################################################
  private

  def network_name_human(network)
    network == :wifi ? "wi-fi" : "ethernet"
  end

  def network_wait_time(network)
    network == :wifi ? 6 : 12
  end

  def network_accessible(network)
    case network
    when :ether
      get_info(network)[:connected]
    when :wifi
      get_info(network)[:network]
    end
  end

  def network_connect_timeout_msg(network)
    case network
    when :wifi
      puts indent "WARNING: No network has yet been joined!".YELLOW
      puts indent "         You may need to manually select a wi-fi network. (or wait longer)"
    when :ether
      puts indent "WARNING: No connection!".YELLOW
      puts indent "         Check the network cable. (or wait longer)".YELLOW
    end
  end

  def toggle_private()
    ether = get_info(:ether)
    wifi  = get_info(:wifi)
    
    preferred_network = :wifi
    preferred_network_name = network_name_human(preferred_network)

    if network_accessible(:ether) && network_accessible(:wifi) 
      puts indent "Both networks are available."
      puts indent "Switching to '#{preferred_network_name}'..."
      network_to_turn_off = preferred_network == :ether ? :wifi : :ether
      turn_off(network_to_turn_off)
      return
    end
    if !network_accessible(:ether) && !network_accessible(:wifi) 
      puts indent "Neither network is available."
      puts indent "Switching to '#{preferred_network_name}'..."
      turn_on(preferred_network)
      return
    end
    new_network = network_accessible(:ether) ? :wifi : :ether
    puts indent "Switching to #{new_network}"
    switch_to(new_network)
  end

  def details_private(network)
    info = get_info(network)
    puts indent "Current status of "+"#{network_name_human(network)}".CYAN+" network:"
    indenter do
      info.keys.sort.each do |key|
        the_key=key
        if %w{enabled network connected}.include?(key.to_s)
          if info[key]
            the_key="#{key}".GREEN
          else
            the_key="#{key}".RED
          end
        end
        puts indent "#{the_key}: #{info[key]}"
      end
    end
  end

  def status_private(network = nil)
    if ! network
      puts indent "Network status, in priority order:"
      order[:order].each do |item|
        status(item)
      end
      indenter do
        network_violation_check
      end
      return
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
    msg = ""
    if info[:enabled] && connected
      msg += "#{info[:name]}".GREEN
    else
      msg += "#{info[:name]}".RED
    end
    msg += ": "
    msg += (info[:enabled] ? "enabled".GREEN : "disabled".RED)
    case network
    when :ether
      msg += (connected ? ", connected".GREEN : ", "+"disconnected".RED) if info[:enabled]
    when :wifi
      msg += (connected ? ", network: #{info[:network].GREEN}" : '')
    end
    msg += " (ip: #{info[:ip]})" if info[:ip]
    puts indent msg
  end

  def proxy_query_private()
    if PROXY_VARS.any? { |var| ENV[var] }
      puts indent("proxy env vars ARE set")
    else
      puts indent("proxy env vars are NOT set")
    end
  end

  def proxy_set_private()
    ether = get_info(:ether)
    wifi  = get_info(:wifi)

    proxy_vars_should_be_on = network_requires_proxy?()
    proxy_vars_are_on = PROXY_VARS.any? { |var| ENV[var] }

    proxy_vars_set_correctly = ! ( proxy_vars_should_be_on ^ proxy_vars_are_on )

    if proxy_vars_set_correctly
      status = proxy_vars_should_be_on ? "(they are set)" : "(they are not set)"
      puts indent "proxy vars are set correctly #{status}"
      return
    end

    msg = ""
    if proxy_vars_should_be_on
      proxy="#{DEFAULT_PROXY}:#{DEFAULT_PROXY_PORT}"
      if File.exist?(PROXY_OVERRIDE_FILE)
        proxy=File.read(PROXY_OVERRIDE_FILE).chomp
        msg += "(note: using proxy server/port found in #{PROXY_OVERRIDE_FILE})"
        proxy=proxy.sub(%r{https:/},'')
        proxy=proxy.sub(%r{http:/},'')
      else
        msg += "using default proxy server/port (override file #{PROXY_OVERRIDE_FILE} not found)"
      end
      PROXY_VARS.each do |var|
        protocol = ( var =~ /https/i ) ? 'https' : 'http'
        puts "export #{var}=#{protocol}://#{proxy};" unless ENV[var]
      end
      puts indent "# proxy vars should be set!"
      puts indent "# set them with: \"eval $(#{THIS_FILE} proxy)\""
      puts indent msg
    else
      proxy_vars=""
      PROXY_VARS.each do |var|
        proxy_vars += "#{var} " if ENV[var]
      end
      unless proxy_vars.empty?
        puts indent "proxy vars should not be set"
        puts indent "unset them with: \"eval $(#{THIS_FILE} proxy)\""
        puts        "unset #{proxy_vars};"
      end
    end
  end

  def turn_off_private(network)
    puts indent "Turning off #{network_name_human(network)}"
    success = true
    netinfo = get_info(network)
    if ! netinfo[:enabled]
      indenter do
        puts indent "#{network_name_human(network)} is already off".CYAN
      end
      return success 
    end
    indenter do
      cmd = case network
            when :ether
              "networksetup -setnetworkserviceenabled '#{netinfo[:name]}' off"
            when :wifi
              "networksetup -setairportpower '#{netinfo[:device]}' off"
            end
      puts indent "+ #{cmd}" if verbose?
      status = `#{cmd}`
      puts status unless status.empty?
      success = $?.exitstatus == 0
      if success
        puts indent "#{network_name_human(network)} now "+"disabled".RED
      else
        puts indent "ERROR turning off #{network_name_human(network)}!".RED
      end
      refresh_network_info()
    end
    return success
  end

  def indent(str)
    @@indent+str.to_s
  end

  def indenter()
    begin
      if @@indent.empty?
        @@indent = "# "
      else
        @@indent = @@indent += "  "
      end
      yield
    ensure
      @@indent = @@indent[0..-3]
    end
  end

  def turn_on_private(network_sym)
    network      = get_info(network_sym)
    network_name = network_name_human(network_sym)
    puts indent "Turning on #{network_name}"
    indenter do
      if network[:enabled]
        msg = "#{network_name} is already on".CYAN
        case network_sym
        when :ether
          unless network[:connected]
            msg += " (but "+"there is no connection... check the network cable".YELLOW+")"
          end
        when :wifi
          if network[:network]
            msg += " (and connected to '#{network[:network].GREEN}')"
          else
            msg += " (but "+"not connected".RED+" to any network)"
          end
        end
        puts indent msg
        return
      end
      case network_sym
      when :ether
        cmd="networksetup -setnetworkserviceenabled '#{network[:name]}' on"
      when :wifi
        cmd="networksetup -setairportpower '#{network[:device]}' on"
      end
      puts indent "+ #{cmd}" if verbose?
      system "#{cmd}"
      network = get_info(network_sym, refresh: true)
      if network[:enabled]
        seconds_to_wait=network_wait_time(network_sym)
        begin
          wait_time = seconds_to_wait
          status = Timeout::timeout(seconds_to_wait) do
            msg = ""
            msg += "#{network_name} now " + "enabled".GREEN
            if network_accessible(network_sym)
              case network_sym
              when :ether
                msg += " and "+"connected".GREEN              
              when :wifi
                msg += " and connected (to '#{network[:network].GREEN}')"
              end
              puts indent msg
              break
            end
            print indent msg
            print ", waiting for connection..."
            puts if verbose?
            while true do
              print (wait_time == seconds_to_wait) ? " " : ", "
              print "#{wait_time}"
              puts if verbose?
              wait_time -= 1
              sleep 1
              network = get_info(network_sym, refresh: true)
              if network_accessible(network_sym)
                puts
                case network_sym
                when :ether
                  puts indent "now connected (ip: #{network[:ip].GREEN})"
                when :wifi
                  puts indent "now connected to '#{network[:network].GREEN}'"
                end
                break
              end
            end
          end
        rescue Timeout::Error
          # force reload of network state (timeout expiration may have interrupted a state reload)
          get_info(network_sym, refresh: true)
          puts # to get on a new line
          network_connect_timeout_msg(network_sym)
        end
      else
        puts indent "#{network_name} is " + "disabled".RED
      end
    end
    network_violation_check
  end

  def refresh_network_info()
    @wifi_info     = nil
    @ether_info    = nil
    @network_order = nil
    @networks      = nil
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
    return turn_off(leaving_network) && turn_on(joining_network)
  end

  def network_violation_check()
  # check if we are on both a proxied network and a non-proxied network
    if mixed_network?
      proxy_network_in_use = ether_requires_proxy? ? 'ethernet' : 'wifi'
      other_network_in_use = ether_requires_proxy? ? 'wifi'     : 'ethernet'
      puts indent "WARNING: Proxied network is enabled (#{proxy_network_in_use}), but so is a non-proxied network (#{other_network_in_use})!".YELLOW
      puts indent "         This can be a security risk.".YELLOW
      puts indent "         You should turn off one of the networks.".YELLOW
    end
  end

  def get_info(network, options = {})
    refresh_network_info() if options[:refresh]
    case network
    when :wifi
      return @wifi_info if @wifi_info
      get_wifi_info()
    when :ether
      return @ether_info if @ether_info
      get_ether_info()
    end
  end

  def get_wifi_info(options = {})
    refresh_network_info() if options[:refresh]
    return @wifi_info if @wifi_info

    # Get device id, and whether enabled
    @wifi_info = networks()[:wifi]
    @wifi_info[:enabled] = nil
    cmd="networksetup -getairportpower '#{@wifi_info[:device]}'"
    puts indent "+ #{cmd}" if verbose?
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
    puts indent "+ #{cmd}" if verbose?
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
    puts indent "+ #{cmd}" if verbose?
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

  def get_ether_info(options = {})
    refresh_network_info() if options[:refresh]
    return @ether_info if @ether_info

    @ether_info = networks()[:ether]
    @ether_info[:connected] = false
    @ether_info[:enabled]   = true
    cmd = "networksetup -getinfo '#{@ether_info[:name]}'"
    puts indent "+ #{cmd}" if verbose?
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
    current_network = {}
    cmd = "networksetup -listnetworkserviceorder"
    puts indent "+ #{cmd}" if verbose?
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
        matches = line.match(/^.*Device: (.*)\)$/)
        current_network[:device] = matches[1]
      end
    end
  end
end
