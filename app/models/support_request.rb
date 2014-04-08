class SupportRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :treatment_area

  after_create :send_notification

  scope :active, -> { where(resolved: false) }

  def description
    description = [user.name]

    if treatment_area && treatment_area != TreatmentArea.radiology
      description.insert 0, treatment_area.name
    end

    description.join(" ")
  end

  private

  def send_notification
    Resque.enqueue(SupportNotification, description, created_at)
  rescue
    # Sometimes, redis is down. I still want to know about this support request
    true
  end
end
