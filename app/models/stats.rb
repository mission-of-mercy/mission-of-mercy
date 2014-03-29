class Stats
  include ActionView::Helpers::TextHelper

  def initialize(session)
    @session = session
  end

  def procedure_added
    add_stat(:procedures, "added", "procedure")
  end

  def patient_checked_out
    add_stat(:patients_checked_out, "checked out", "patient")
  end

  def patient_checked_in
    add_stat(:patient_checked_in, "checked in", "patient")
  end

  def exclamation(number)
    return "You're on fire!"    if number == 20
    return "Now you're cookin!" if number == 50

    exclamations = ["Great work", "Awesome", "Nice job", "Way to go",
      "Hey there", "Great job"]

    exclamations[rand(exclamations.length)] + "!"
  end

  def messages
    messages = data[:messages].dup
    data[:messages].clear

    return messages
  end

  def data
    session[:stats] ||= begin
      data            = Hash.new(0)
      data[:messages] = Array.new
      data
    end
  end

  private

  attr_reader :session

  def add_stat(type, verb, object)
    data[type] += 1

    message = [ exclamation(data[type]),
                "You've #{verb} #{pluralize(data[type], object)} today."
              ].join(" ")

    data[:messages] << message
  end
end
