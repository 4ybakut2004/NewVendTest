NewVend::Application.routes.draw do
  get "machines/new"
  get 'request_tasks/count' => 'request_tasks#count'

  resources :machines, only: [:index, :show, :create, :new]
  resources :users, only: [:show, :edit, :update, :new, :create, :index]
  resources :sessions, only: [:new, :create, :destroy]
  resources :requests, only: [:index, :destroy, :create, :update, :edit, :show]
  resources :messages, only: [:index, :destroy, :create, :update, :edit]
  resources :request_tasks, only: [:index, :edit, :update, :show]
  resources :tasks, only: [:index, :create, :destroy, :update]
  resources :employees, only: [:index, :create, :destroy, :edit, :update]
  resources :message_tasks, only: [:index]
  resources :attributes, only: [:index, :create, :destroy, :update]
  resources :request_types, only: [:index, :create, :destroy, :update, :show]
  resources :new_vend_settings, only: [:index, :show, :update]

  root  'static_pages#home'
  match '/help',    to: 'static_pages#help',    via: 'get'

  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'

  get 'to_assign_count' => 'request_tasks#to_assign_count', :as => :to_assign_count
  get 'to_audit_count' => 'request_tasks#to_audit_count', :as => :to_audit_count
  get 'to_execute_count' => 'request_tasks#to_execute_count', :as => :to_execute_count
  get 'to_read_assign_count' => 'request_tasks#to_read_assign_count', :as => :to_read_assign_count
  get 'to_read_execute_count' => 'request_tasks#to_read_execute_count', :as => :to_read_execute_count
  get 'to_read_by_executor_count' => 'request_tasks#to_read_by_executor_count', :as => :to_read_by_executor_count
  get 'to_read_by_assigner_count' => 'request_tasks#to_read_by_assigner_count', :as => :to_read_by_assigner_count
  get 'to_read_by_auditor_count' => 'request_tasks#to_read_by_auditor_count', :as => :to_read_by_auditor_count
  get 'to_read_by_employee_count' => 'request_tasks#to_read_by_employee_count', :as => :to_read_by_employee_count
  get 'read_request_task' => 'request_tasks#read', :as => :read_request_task
  get 'current_employee' => 'employees#current_employee', :as => :current_employee
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
