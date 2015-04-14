class PatientPreMed < ActiveRecord::Base
  after_save :destroy_unless_prescribed

  belongs_to :pre_med
  belongs_to :patient

  def full_description
    if pre_med != nil
      pre_med.description
    else
      "Pre Med"
    end
  end

  private

  def destroy_unless_prescribed
    destroy unless prescribed
  end
end
