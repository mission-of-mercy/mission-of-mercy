class PatientProcedure < ActiveRecord::Base

  VALID_TOOTH   = /\A[A-T]\Z|\A[1-9]\Z|\A[1-2][0-9]\Z|\A3[0-2]\Z|\A[UL][LR]\Z/
  VALID_SURFACE = /\A[FLOMDIB,]+\Z/

  belongs_to :patient
  belongs_to :procedure

  before_validation :normalize_data, :load_procedure_from_code,
                    :load_procedure_from_type, :on => :create

  validates_presence_of :procedure, :message => "invalid"
  validates_format_of :tooth_number, :with => VALID_TOOTH,
    :message => "must be valid (A-T or 1-32)", :allow_blank => true
  validates_format_of :surface_code, :with => VALID_SURFACE,
    :message => "must be valid (Only F,L,O,M,D,I,B)", :allow_blank => true
  validate :procedure_requirements

  attr_accessor :code, :procedure_type

  def self.created_today
    where("patient_procedures.created_at::Date = ?", Date.today)
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
        errors[:base] << "Tooth number can't be blank"
      end

      if procedure.requires_surface_code && (surface_code == nil || surface_code.blank?)
        errors[:base] << "Surface code can't be blank"
      end
    end
  end

  private

  def normalize_data
    self.tooth_number = tooth_number.try(:upcase)
    self.surface_code = surface_code.try(:upcase)
  end

  def load_procedure_from_code
    if !code.blank? && procedure_id == 0
      self.procedure = Procedure.find_by_code(self.code)
    end
  end

  def load_procedure_from_type
    if !procedure_type.blank? and (procedure_id.nil? || procedure_id == 0)
      surface_count = surface_code.gsub(/\s|,/, "").length
      surface_count = 4 if surface_count > 4

      if procedure_type == "Amalgam"
        self.procedure = Procedure.find(:first,
          :conditions => { :procedure_type     => procedure_type,
                           :number_of_surfaces => surface_count
                         })
      else
        # Find out if Post or Ant ...
        tooth_numb = self.tooth_number.to_i

        if tooth_numb.between?(1,5) ||
           tooth_numb.between?(12,16) ||
           tooth_numb.between?(17,21) ||
           tooth_numb.between?(28,32) ||
           tooth_number.between?("A","B") ||
           tooth_number.between?("I","J") ||
           tooth_number.between?("K","L") ||
           tooth_number.between?("S","T")

          self.procedure = Procedure.find(:first,
            :conditions => { :procedure_type     => "Post Composite",
                             :number_of_surfaces => surface_count
                           })

        elsif tooth_numb.between?(6,11) ||
              tooth_numb.between?(22,27) ||
              tooth_number.between?("C","H") ||
              tooth_number.between?("M","R")

          self.procedure = Procedure.find(:first,
            :conditions => { :procedure_type     => "Ant Composite",
                             :number_of_surfaces => surface_count
                           })

        end
      end
    end
  end
end
