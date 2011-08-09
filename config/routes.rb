ActionController::Routing::Routes.draw do |map|

  map.root :controller => :home, :action => :index

  map.home '/', :controller => :home, :action => :index

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'

  map.resource :session

  map.resources :support_requests
  map.connect '/active_support_requests.:format', :controller => "support_requests", :action => "active_requests"

  map.resources :treatment_areas, :collection => {:change => :post} do |area|
    area.resources :patients,
                   :controller => "treatment_areas/patients" do |patient|
      patient.resources :prescriptions, :controller => "treatment_areas/patients/prescriptions"
      patient.resources :procedures,    :controller => "treatment_areas/patients/procedures"
      patient.resource  :survey,        :controller => "treatment_areas/patients/surveys"
    end
  end

  map.pharmacy_check_out '/pharmacy/check_out/:patient_id', :controller => :pharmacy, :action => :check_out
  map.pharmacy_finalize  '/pharmacy/finalize/:patient_id',  :controller => :pharmacy, :action => :check_out_complete
  map.resources :patients, :collection => { :lookup_zip => :get, :lookup_city => :post }
  map.resources :patient_procedures

  map.resources :assignment_desk

  map.print_chart '/patients/:id/print', :controller => 'patients', :action => 'print'

  map.export_to_dexis_file '/patients/:patient_id/export', :controller => 'patients', :action => 'export_to_dexis_file'

  map.status '/status', :controller => 'status', :action => 'index'

  map.namespace :admin do |admin|
    admin.resources :treatment_areas
    admin.resources :procedures
    admin.resources :pre_meds
    admin.resources :prescriptions
    admin.resources :users
    admin.resources :support_requests, :collection => {:destroy_all => :delete}

    admin.reports                            '/reports',
                                             :controller => 'reports',
                                             :action     => 'index'
    admin.clinic_summary_report              '/reports/clinic_summary/',
                                             :controller => 'reports',
                                             :action     => 'clinic_summary'
    admin.treatment_area_distribution_report '/reports/treatment_area_distribution',
                                             :controller => 'reports',
                                             :action     => 'treatment_area_distribution'
    admin.post_clinic_report                 '/reports/post_clinic',
                                             :controller => 'reports',
                                             :action     => 'post_clinic'
    admin.export_patients                    '/reports/export_patients',
                                             :controller => 'reports',
                                             :action     => 'export_patients'
    admin.maintenance                        '/maintenance',
                                             :controller => 'maintenance',
                                             :action     => 'index'
    admin.maintenance_reset                  '/maintenance/reset',
                                             :controller => 'maintenance',
                                             :action     => 'reset'
  
  
  end

end
