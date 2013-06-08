namespace "2013" do
  task :survey => [:environment] do
    ActiveRecord::Base.transaction do
      keepers = Patient.select("survey_id").where("survey_id IS NOT NULL").
        map(&:survey_id)

      Survey.where("id NOT IN (?)", keepers).delete_all

      Survey.where(age: nil).find_each do |survey|
        patient = Patient.where(survey_id: survey.id).first

        if patient
          survey.update_patient_information(patient)
          survey.save
        else
          # This is an orphaned survey, but we already deleted those WTF!
          raise survey.inspect
        end
      end
    end
  end
end
