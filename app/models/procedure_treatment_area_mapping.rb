class ProcedureTreatmentAreaMapping < ActiveRecord::Base
  after_save    :destroy_unless_assigned

  belongs_to :procedure
  belongs_to :treatment_area

  private

  def destroy_unless_assigned
    destroy unless assigned
  end
end
