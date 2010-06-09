ActionController::Routing::Routes.draw do |map|

  map.root :controller => :home, :action => :index
  
  map.home '/', :controller => :home, :action => :index
  
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'

  map.resources :users

  map.resource :session

  map.resources :support_requests
  map.connect '/active_support_requests.:format', :controller => "support_requests", :action => "active_requests"
  
  map.treatment_area_assign '/treatment_areas/assign/:patient_id',
                            :controller => "treatment_areas",
                            :action => "assign", 
                            :conditions => { :method => :get }
                            
  map.connect '/treatment_areas/assign/:patient_id',
              :controller => "treatment_areas",
              :action => "assign_complete", 
              :conditions => { :method => :put }
  
  map.treatment_area_checkout '/treatment_areas/:treatment_area_id/checkout/:patient_id',
                               :controller => "treatment_areas", 
                               :action => "check_out", 
                               :conditions => { :method => :get }
  
  map.connect '/treatment_areas/:treatment_area_id/checkout/:patient_id', 
              :controller => "treatment_areas", 
              :action => "check_out_post",
              :conditions => { :method => :post }
              
  map.treatment_area_pre_checkout '/treatment_areas/:treatment_area_id/pre_checkout/:patient_id',
                               :controller => "treatment_areas", 
                               :action => "pre_check_out", 
                               :conditions => { :method => :get }

  map.connect '/treatment_areas/:treatment_area_id/pre_checkout/:patient_id', 
              :controller => "treatment_areas", 
              :action => "pre_check_out_post",
              :conditions => { :method => :put }
              
  map.check_out_completed '/treatment_areas/:treatment_area_id/checkout/:patient_id/finish',
                          :controller => "treatment_areas", 
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
  
  map.resources :treatment_areas
  
  map.resources :patient_procedures

  map.resources :patients, :has_many => [:patient_prescriptions,:patient_procedures]
  
  map.print_chart '/patients/:id/print', :controller => 'patients', :action => 'print'

  map.export_to_dexis_file '/patients/:patient_id/export', :controller => 'patients', :action => 'export_to_dexis_file'
  
  map.status '/status', :controller => 'status', :action => 'index'
  
  map.namespace :admin do |admin|
    admin.resources :treatment_areas
    admin.resources :procedures
    admin.resources :pre_meds
    admin.resources :prescriptions
    
    admin.reports '/reports', :controller => 'reports', :action => 'index'
    admin.clinic_summary_report '/reports/clinic_summary/', :controller => 'reports', :action => 'clinic_summary'
    admin.treatment_area_distribution_report '/reports/treatment_area_distribution', :controller => 'reports', :action => 'treatment_area_distribution'
    admin.post_clinic_report '/reports/post_clinic', :controller => 'reports', :action => 'post_clinic'
  end
  
end
