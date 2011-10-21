MissionOfMercy::Application.routes.draw do
  devise_for :users

  root :to => 'home#index'

  match '/' => 'home#index' # I am not sure we need this

  match '/logout' => 'sessions#destroy'
  
  match '/login' => 'sessions#new'
  
  resource :session
  
  resources :support_requests
  
  match '/active_support_requests.:format' =>  'support_requests#active_requests'
  
=begin
  Not sure about this route. will come back later.  
  map.resources :treatment_areas, :collection => {:change => :post} do |area|
    area.resources :patients,
                   :controller => "treatment_areas/patients" do |patient|
      patient.resources :prescriptions, :controller => "treatment_areas/patients/prescriptions"
      patient.resources :procedures,    :controller => "treatment_areas/patients/procedures"
      patient.resource  :survey,        :controller => "treatment_areas/patients/surveys"
    end
  end
=end  

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
