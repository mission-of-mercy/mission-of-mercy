module Support
  class SimulatedCheckInUser < SimulatedUser
    def sign_in
      browser { sign_in_as "Check in" }
    end

    def register_a_new_patient(options = {})
      browser { click_link "No, this is a new patient" }

      agree_to_waver
      fill_out_registation_form

      browser do
        click_button "Next"
        click_button "Finish"
      end
    end

    def agree_to_waver
      browser { click_button "waiver_agree_button" }
    end

    # FIXME Pull these options from the options hash
    def fill_out_registation_form(options = {})
      browser do
        fill_in 'First name',                :with => 'Jordan'
        fill_in 'Last name',                 :with => 'Byron'
        fill_in 'Date of birth',             :with => '12/26/1985'
        select  'M',                         :from => 'Sex'
        fill_in 'City',                      :with => 'Cheshire'
        select  'CT',                        :from => 'State'
        select  'New Haven',                 :from => 'County'
        select  'Cleaning',                  :from => "patient_chief_complaint"
        select  'Excellent',                 :from => 'patient_overall_health'
        select  'English',                   :from => 'Language'
        choose  'patient_consent_to_research_study_true'
        choose  'patient_pain_false'
      end
    end

    def close_previous_patient_facebox
      browser { click_link "Check In Next Patient" }
    end
  end
end
