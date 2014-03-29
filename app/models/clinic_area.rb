class ClinicArea
  def self.add_enum(key,value)
    @hash ||= {}
    @hash[key]=value
  end

  def self.const_missing(key)
    @hash[key]
  end

  def self.each
    @hash.each {|key,value| yield(key,value)}
  end

  def self.[](value)
    @hash.select {|k,v| v == value }.flatten.first
  end

  self.add_enum :CHECKIN, 1
  self.add_enum :XRAY, 2
  self.add_enum :ASSIGNMENT, 3
  self.add_enum :CHECKOUT, 4
  self.add_enum :PHARMACY, 5
end
