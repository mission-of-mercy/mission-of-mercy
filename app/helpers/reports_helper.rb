module ReportsHelper


  def time_spans
    ["All","6:00 AM", "7:00 AM", "8:00 AM", "9:00 AM", "10:00 AM", "11:00 AM","12:00 PM", "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM"]
  end
  
  def days(report)
    (["All"] + Patient.all(:group => report.date_sql("patients")).map {|p| p.created_at.to_date } + [report.day]).uniq
  end
  
  def edit_town(town)
    button_to_function "Edit", 
                       "$('town_#{town['city']}').update('<input type=\"text\" value=\"#{town['city']}\"></input>'); $(this).hide(); $('save_#{town['city']}').show()"
  end
  
  def save_town(town)
    button_to_function "Save",
                       "#",
                       :id => "save_#{town['city']}"
                       :style => "display:none;"
  end
end
