module ReportsHelper


  def timeArray
    ["6:00 AM", "7:00 AM", "8:00 AM", "9:00 AM", "10:00 AM", "11:00 AM","12:00 PM", "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM"]
  end

  def day_selection(day)
    options = "<option value=''>All Day</option>"
    timeArray.each do |d|
      shortD = d.gsub(" ","")
      if shortD == day
        options += "<option value=#{shortD} selected='selected'>#{d}</option>"
      else
        options += "<option value=#{shortD}>#{d}</option>"
      end
    end
     options
  end
  
  def day_selection_full_name(day)
    result = "All Day"
    
    timeArray.each do |d|
      shortD = d.gsub(" ","")
      if shortD == day
        result = day
      end
    end
    
    result
  end

end
