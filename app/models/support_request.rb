class SupportRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :treatment_area

  def station_description
    des = []
    des << treatment_area.name if treatment_area
    des << user.name if user

    des.compact.join(" ")
  end

  def to_hash
    {
      :ip_address           => ip_address,
      :station_description  => station_description
    }
  end
end
