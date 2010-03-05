class SupportRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :treatement_area
  
  def station_description
    des = "<b>"
    
    des += treatement_area.name if treatement_area
    des += " #{user.name}" if user
    #des += " (#{ip_address})"
    
    des + "</b>"
  end
  
  def to_hash
    {
      :ip_address           => ip_address,
      :station_description  => station_description
    }
  end
end
