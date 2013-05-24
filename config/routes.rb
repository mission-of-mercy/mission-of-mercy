MissionOfMercy::Application.routes.draw do
  devise_for :users

  root :to => 'home#index'

  devise_scope :user do
    match '/logout' => 'devise/sessions#destroy', :as => :logout
    match '/login'  => 'devise/sessions#new',     :as => :login
  end

  resources :support_requests
  match '/active_support_requests.:format' => 'support_requests#active_requests'

  resources :treatment_areas do
    post :change, :on => :collection
    resources :patients, :module => "TreatmentAreas" do
      get :radiology, :on => :member
      resources :prescriptions, :module => "Patients"
      resources :procedures,    :module => "Patients"
      resource :survey,         :module => "Patients"
    end
  end

  match '/pharmacy/check_out/:patient_id' => 'pharmacy#check_out', :as => :pharmacy_check_out
  match '/pharmacy/finalize/:patient_id' => 'pharmacy#check_out_complete', :as => :pharmacy_finalize

  resources :patients, except: [:destroy, :index, :show] do
    resources :surveys
    member do
      get :chart
    end
    collection do
      get :reprint
      get :previous
    end
  end

  match '/autocomplete/city.json' => 'autocomplete#city', :as => :autocomplete_city
  match '/autocomplete/zip.json'  => 'autocomplete#zip',  :as => :autocomplete_zip
  match '/autocomplete/race.json'  => 'autocomplete#race',  :as => :autocomplete_race
  match '/autocomplete/heard_about_clinic.json'  => 'autocomplete#heard_about_clinic',  :as => :autocomplete_heard_about_clinic

  resources :patient_procedures
  resources :assignment_desk

  match '/patients/:patient_id/radiology' => 'patients#radiology', :as => :patient_radiology

  namespace :admin do
    resources :treatments
    resources :treatment_areas
    resources :procedures
    resources :pre_meds
    resources :prescriptions
    resources :users
    resources :patients do
      get 'history', :on => :member
    end
    resources :support_requests do
      collection do
        delete :destroy_all
      end
    end
    match '/reports' => 'reports#index', :as => :reports
    match '/reports/clinic_summary/' => 'reports#clinic_summary', :as => :clinic_summary_report
    match '/reports/treatment_area_distribution' => 'reports#treatment_area_distribution', :as => :treatment_area_distribution_report
    match '/reports/post_clinic' => 'reports#post_clinic', :as => :post_clinic_report
    match '/reports/export_patients' => 'reports#export_patients', :as => :export_patients
    match '/maintenance' => 'maintenance#index', :as => :maintenance
    match '/maintenance/reset' => 'maintenance#reset', :as => :maintenance_reset
  end

  match '/dashboard/patients'         => 'dashboard#patients'
  match '/dashboard/summary'          => 'dashboard#summary'
  match '/dashboard/support'          => 'dashboard#support'
  match '/dashboard/treatment_areas'  => 'dashboard#treatment_areas'
end
