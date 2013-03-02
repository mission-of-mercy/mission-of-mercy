module TestHelper
  extend self

  # December, 26, 1985 + a user-defined time
  def clinic_date(time=nil)
    date = "12/26/1985"

    if time
      m, d, y = date.split('/')
      Time.zone.parse("#{[y, m, d] * '-'} #{time}")
    else
      Date.strptime(date, "%m/%d/%Y")
    end
  end

  def valid_patient
    FactoryGirl.build(:patient)
  end

  def create_test_patients(date=Date.today)
    (6..17).map { |i| date + i.hours }.each do |datetime|
      FactoryGirl.create(:patient, :created_at => datetime, :updated_at => datetime)
    end
  end

  def create_test_prescriptions
    FactoryGirl.create(:prescription,
                       :name     => "Amoxicillin",
                       :quantity => 21,
                       :dosage   => "500mg",
                       :cost     => 12.99,
                       :strength => "1 YID x 7days")
  end

  def create_test_procedures
    FactoryGirl.create(:procedure,
                       :description => "Comp. Oral Exam",
                       :code        => 150,
                       :cost        => 90)
    FactoryGirl.create(:procedure,
                       :description => "Panoramic film",
                       :code        => 330,
                       :cost        => 125)
  end

  def create_test_xray(time, patient)
    FactoryGirl.create(:patient_flow,
                       :area_id    => ::ClinicArea::XRAY,
                       :patient    => patient,
                       :created_at => time)
  end
end
