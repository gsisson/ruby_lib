class Date2
  def self.valid_date?(date)
    return true if date.match(@@pattern_date1)
    return true if date.match(@@pattern_date2)
    false
  end
  def self.valid_date_time?(date_time)
    return true if date_time.match(@@pattern_date_time1)
    return true if date_time.match(@@pattern_date_time2)
    false
  end
  def self.valid_date_x?(date)
    return true if date.match(@@pattern_date_x1)
    return true if date.match(@@pattern_date_x2)
    false
  end
  def self.valid_date_time_x?(date_time)
    return true if date_time.match(@@pattern_date_time_x1)
    return true if date_time.match(@@pattern_date_time_x2)
    false
  end
  def self.prefix_for_file(date_or_date_time)
       self.prefix_for(date_or_date_time, @@pattern_date_time1, @@pattern_date1) \
    || self.prefix_for(date_or_date_time, @@pattern_date_time2, @@pattern_date2)
  end
  def self.corrected_prefix_for_file(date_or_date_time)
       self.corrected_prefix_for(date_or_date_time, @@pattern_date_time1, @@pattern_date1) \
    || self.corrected_prefix_for(date_or_date_time, @@pattern_date_time2, @@pattern_date2)
  end
  def self.prefix_for_file_x(date_or_date_time)
       self.prefix_for(date_or_date_time, @@pattern_date_time_x1, @@pattern_date_x1) \
    || self.prefix_for(date_or_date_time, @@pattern_date_time_x2, @@pattern_date_x2)
  end
  def self.corrected_prefix_for_file_x(date_or_date_time)
       self.corrected_prefix_for(date_or_date_time, @@pattern_date_time_x1, @@pattern_date_x1) \
    || self.corrected_prefix_for(date_or_date_time, @@pattern_date_time_x2, @@pattern_date_x2)
  end
  # private
  def self.prefix_for(date_or_date_time, pattern_date_time, pattern_date)
    if match = date_or_date_time.match(pattern_date_time)
      prefix=match.captures[0..11].join
      base = date_or_date_time.sub(prefix,'')
      return date_or_date_time.sub(/#{Regexp.quote(base)}/,'')
    end
    if match = date_or_date_time.match(pattern_date)
      prefix=match.captures[0..4].join
      base = date_or_date_time.sub(prefix,'')
      return date_or_date_time.sub(/#{Regexp.quote(base)}/,'')
    end
    nil
  end
  def self.handle_date_time(match)
    year, _x, month, _x, day, _x, hours, _x, minutes, _x, seconds, ampm = match.captures
    # 0    1    2     3   4    5    6     7     8      9    10      11
    # ^^^^^^^^^^^^^^  the captures  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    if ampm && ampm =~ /PM/
      hours = (hours.to_i + 12).to_s
    end
    if day.length > 2 # 2008-01-31 <= 01-31-2008
      year, month, day = day, year, month
    end
    month   = "0#{month}"   if   month.length == 1
    day     = "0#{day}"     if     day.length == 1
    hours   = "0#{hours}"   if   hours.length == 1
    minutes = "0#{minutes}" if minutes.length == 1
    seconds = "0#{seconds}" if seconds.length == 1
    return "#{year}-#{month}-#{day}_#{hours}.#{minutes}.#{seconds}"
  end
  def self.handle_date(match)
    year,  _x, month, _x, day = match.captures
    # 0     1    2     3   4
    # ^^    the captures  ^^
    if day.length > 2 # 2008-01-31 <= 01-31-2008
      year, month, day = day, year, month
    end
    month   = "0#{month}"   if   month.length == 1
    day     = "0#{day}"     if     day.length == 1
    return "#{year}-#{month}-#{day}"
  end
  def self.corrected_prefix_for(date_or_date_time, pattern_date_time, pattern_date)
    match = date_or_date_time.match(pattern_date_time)
    if match
      return handle_date_time(match)
    end
    match = date_or_date_time.match(pattern_date)
    if match
      return handle_date(match)
    end
    nil
  end
  def self.guess_and_return_date_time_prefix filename
    prefix = \
      Date2.prefix_for(filename, @@pattern_date_time_x1, @@pattern_date_x1) ||
      Date2.prefix_for(filename, @@pattern_date_time_x2, @@pattern_date_x2)
    return nil if ! prefix
    prefix = filename[0..prefix.length-1]
    base = filename.sub(/^#{Regexp.quote(prefix)}/,'')
    return filename.sub(/#{Regexp.quote(base)}$/,'')
  end
  def self.guess_and_remove_date_time_prefix filename
    prefix = guess_and_return_date_time_prefix filename
    return filename if ! prefix 
    base = filename.sub(/^#{Regexp.quote(prefix)}/,'')
    if base =~ /^[ _\.]/
      base=base.sub(/^[ _\.]/,'')
    end
    return "image.#{base}" if base =~ /^...$/i
    base
  end

  year='([\dX][\dX][\dX][\dX])'
  two='([\dX][\dX]?)'
  d='([-_:\.])' #'([-:\.])'
  ampm='([ ][AP]M)?'
  @@pattern_date1        = /^(\d\d\d\d)#{d}(\d\d)#{d}(\d\d)([^\/]*)$/
  @@pattern_date2        = /^(\d\d)#{d}(\d\d)#{d}(\d\d\d\d)([^\/]*)$/
  @@pattern_date_time1   = /^(\d\d\d\d)#{d}(\d\d)#{d}(\d\d)([ -_\.])(\d\d)#{d}(\d\d)#{d}(\d\d)#{ampm}([^\/]*)$/i
  @@pattern_date_time2   = /^(\d\d)#{d}(\d\d)#{d}(\d\d\d\d)([ -_\.])(\d\d)#{d}(\d\d)#{d}(\d\d)#{ampm}([^\/]*)$/i
  @@pattern_date_x1      = /^#{year}#{d}#{two}#{d}#{two}([^\/]*)$/
  @@pattern_date_x2      = /^#{two}#{d}#{two}#{d}#{year}([^\/]*)$/
  @@pattern_date_time_x1 = /^#{year}#{d}#{two}#{d}#{two}([ -_\.])#{two}#{d}#{two}#{d}#{two}#{ampm}([^\/]*)$/i
  @@pattern_date_time_x2 = /^#{two}#{d}#{two}#{d}#{year}([ -_\.])#{two}#{d}#{two}#{d}#{two}#{ampm}([^\/]*)$/i
end
