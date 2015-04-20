
MissionOfMercy::Application.routes.draw do
  devise_for :users

  root :to => 'home#index'

  devise_scope :user do
    get '/logout' => 'devise/sessions#destroy', :as => :logout
    get '/login'  => 'devise/sessions#new',     :as => :login
  end

  resources :support_requests
  get '/active_support_requests.:format' => 'support_requests#active_requests'

  resources :treatment_areas do
    post :change, :on => :collection
    resources :patients, :controller => "treatment_areas/patients" do
      get :radiology, :on => :member
      resource :survey,
        :controller => "treatment_areas/patients/surveys"
      resources :procedures,
        :controller => "treatment_areas/patients/procedures"
      resources :prescriptions,
        :controller => "treatment_areas/patients/prescriptions"
    end
  end

  get '/pharmacy' => 'pharmacy#index'
  get '/pharmacy/check_out/:patient_id' => 'pharmacy#check_out', :as => :pharmacy_check_out
  patch '/pharmacy/finalize/:patient_id' => 'pharmacy#check_out_complete', :as => :pharmacy_finalize

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

  get '/autocomplete/city.json' => 'autocomplete#city', :as => :autocomplete_city
  get '/autocomplete/zip.json'  => 'autocomplete#zip',  :as => :autocomplete_zip
  get '/autocomplete/race.json'  => 'autocomplete#race',  :as => :autocomplete_race
  get '/autocomplete/heard_about_clinic.json'  => 'autocomplete#heard_about_clinic',  :as => :autocomplete_heard_about_clinic

  resources :patient_procedures
  resources :assignment_desk

  get '/patients/:patient_id/radiology' => 'patients#radiology', :as => :patient_radiology

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
    resources :previous_clinics
    get '/reports' => 'reports#index', :as => :reports
    get '/reports/clinic_summary/' => 'reports#clinic_summary', :as => :clinic_summary_report
    get '/reports/treatment_area_distribution' => 'reports#treatment_area_distribution', :as => :treatment_area_distribution_report
    get '/reports/post_clinic' => 'reports#post_clinic', :as => :post_clinic_report
    get '/reports/export' => 'reports#export'
    get '/maintenance'    => 'maintenance#index', :as => :maintenance
    post '/maintenance/reset' => 'maintenance#reset', :as => :maintenance_reset
    post '/maintenance/clear_support_requests' => 'maintenance#clear_support_requests'
  end

  post '/printer' => 'printer#update'

  get '/dashboard/patients'         => 'dashboard#patients'
  get '/dashboard/summary'          => 'dashboard#summary'
  get '/dashboard/support'          => 'dashboard#support'
  get '/dashboard/treatment_areas'  => 'dashboard#treatment_areas'

  namespace :api do
    resources :patients do
      member do
        get :chart
      end
    end
  end

  resque_web_constraint = lambda do |request|
    current_user = request.env['warden'].user
    current_user.present? && current_user.user_type == UserType::ADMIN
  end

  constraints resque_web_constraint do
    mount ResqueWeb::Engine => "/admin/resque"
  end
end
