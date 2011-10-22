MissionOfMercy::Application.routes.draw do
  devise_for :users
  
  match '/' => 'home#index'
  match '/' => 'home#index', :as => :home
  devise_scope :user do 
    match '/logout' => 'devise/sessions#destroy', :as => :logout
    match '/login' => 'devise/sessions#new', :as => :login
  end 
  
  resources :support_requests
  match '/active_support_requests.:format' => 'support_requests#active_requests'
  resources :treatment_areas do
    collection do
  post :change
  end
  
      resources :patients do
    
    
          resources :prescriptions
      resources :procedures
      resource :survey
    end
  end

  match '/pharmacy/check_out/:patient_id' => 'pharmacy#check_out', :as => :pharmacy_check_out
  match '/pharmacy/finalize/:patient_id' => 'pharmacy#check_out_complete', :as => :pharmacy_finalize
  resources :patients do
    collection do
  get :lookup_zip
  post :lookup_city
  end
  
  
  end

  resources :patient_procedures
  resources :assignment_desk
  match '/patients/:id/print' => 'patients#print', :as => :print_chart
  match '/patients/:patient_id/export' => 'patients#export_to_dexis_file', :as => :export_to_dexis_file
  match '/status' => 'status#index', :as => :status
  namespace :admin do
      resources :treatment_areas
      resources :procedures
      resources :pre_meds
      resources :prescriptions
      resources :users
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
      match '/maintenance/reset_distribution' => 'maintenance#reset_distribution', :as => :maintenance_reset_distribution
  end
  root :to => 'home#index'
end
