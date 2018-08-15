module Helper
  def self.time_divisor(format)
    #for ruby Time instances from Rails
    #Converts from seconds to another format
    if format == "sec"
      divisor = 1
    elsif format == "min"
      divisor = 60
    elsif format == "hour"
      divisor = 3600
    elsif format == "day"
      divisor = 86400
    end
    divisor
  end

  def self.time_multiplier(format)
    #For days produced by SQL queries
    #Converts days to other formats
    if format == "sec"
      multiplier = 86400
    elsif format == "min"
      multiplier = 1440
    elsif format =="day"
      multiplier = 1
    elsif format == "hour"
      multiplier = 24
    end
    multiplier
  end

  def self.convert_ms_to_datetime(ms)
    Time.at(ms/1000)
  end
end
