class PatientProcedure < ActiveRecord::Base
  belongs_to :patient
  belongs_to :procedure
  before_validation_on_create :load_procedure_from_code
  
  validates_presence_of :provider_id, :procedure_id, :message => "invalid"
  validates_format_of :tooth_number, :with => /\A[A-T]\Z|\A[1-9]\Z|\A[1-2][0-9]\Z|\A3[0-2]\Z/, :message => "must be valid (A-T or 1-32)", :allow_blank => true
  validates_format_of :surface_code, :with => /\A[F,L,O,M,D,I,B]+\Z/, :message => "must be valid (Only F,L,O,M,D,I,B)", :allow_blank => true
  validate :procedure_requirements
  
  attr_accessor :code
  
  def self.time_zone_aware_attributes
   false
  end
  
  def full_description
    if procedure != nil
      desc = ["%04d" % procedure.code.to_s,": ",procedure.description].join()
      if tooth_number != nil && tooth_number.length > 0
        desc = [desc," (",tooth_number,")"].join()
      end
      desc
    else
      "Procedure"
    end
  end
  
  def procedure_requirements
    if procedure != nil
      if procedure.requires_tooth_number && (tooth_number == nil || tooth_number.blank?)
        errors.add_to_base("Tooth number can't be blank") # unless commenter.friend_of?(commentee)
      end
      
      if procedure.requires_surface_code && (surface_code == nil || surface_code.blank?)
        errors.add_to_base("Surface code can't be blank") # unless commenter.friend_of?(commentee)
      end
    end
  end
  
  private 
  
  def load_procedure_from_code
    if !self.code.nil? and self.procedure_id == 0
      self.procedure = Procedure.find_by_code(self.code)
    end
  end
end
