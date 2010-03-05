ActionController::Routing::Routes.draw do |map|
  map.root :controller => :home, :action => :index
  
  map.home '/', :controller => :home, :action => :index
  
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'

  map.resources :users

  map.resource :session
  
  map.reports '/reports', :controller => 'reports', :action => 'index'
  map.clinic_summary_report '/reports/clinic_summary/', :controller => 'reports', :action => 'clinic_summary'
  map.treatment_area_distribution_report '/reports/treatment_area_distribution', :controller => 'reports', :action => 'treatment_area_distribution'
  map.resources :providers

  map.resources :prescriptions

  map.resources :support_requests
  map.connect '/active_support_requests.:format', :controller => "support_requests", :action => "active_requests"
  
  map.treatment_area_assign '/treatement_areas/assign/:patient_id',
                            :controller => "treatement_areas",
                            :action => "assign", 
                            :conditions => { :method => :get }
                            
  map.connect '/treatement_areas/assign/:patient_id',
              :controller => "treatement_areas",
              :action => "assign_complete", 
              :conditions => { :method => :put }
  
  map.treatement_area_checkout '/treatement_areas/:treatement_area_id/checkout/:patient_id',
                               :controller => "treatement_areas", 
                               :action => "check_out", 
                               :conditions => { :method => :get }
  
  map.connect '/treatement_areas/:treatement_area_id/checkout/:patient_id', 
              :controller => "treatement_areas", 
              :action => "check_out_post",
              :conditions => { :method => :post }
              
  map.treatement_area_pre_checkout '/treatement_areas/:treatement_area_id/pre_checkout/:patient_id',
                               :controller => "treatement_areas", 
                               :action => "pre_check_out", 
                               :conditions => { :method => :get }

  map.connect '/treatement_areas/:treatement_area_id/pre_checkout/:patient_id', 
              :controller => "treatement_areas", 
              :action => "pre_check_out_post",
              :conditions => { :method => :put }
              
  map.check_out_completed '/treatement_areas/:treatement_area_id/checkout/:patient_id/finish',
                          :controller => "treatement_areas", 
                          :action => "check_out_completed",
                          :conditions => { :method => :post }
  
  map.pharmacy_check_out '/pharmacy/:patient_id/checkout',
                         :controller => "pharmacy",
                         :action     => "check_out",
                         :conditions => { :method => :get }
                         
  map.connect '/pharmacy/:patient_id/checkout',
              :controller => "pharmacy",
              :action     => "check_out_complete",
              :conditions => { :method => :put }
  
  map.resources :treatement_areas

  map.resources :procedures
  
  map.resources :patient_procedures

  map.resources :patients, :has_many => [:patient_prescriptions,:patient_procedures]
  
  map.connect '/patients/:id/print', :controller => 'patients', :action => 'print'

  map.export_to_dexis_file '/patients/:patient_id/export', :controller => 'patients', :action => 'export_to_dexis_file'
  
end
