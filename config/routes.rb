NewVend::Application.routes.draw do
  get "machines/new"
  resources :machines, only: [:index, :show, :create, :new]
  resources :users, only: [:show, :edit, :update, :new, :create, :index]
  resources :sessions, only: [:new, :create, :destroy]
  resources :requests, only: [:index, :destroy, :create, :update, :edit, :show]
  resources :messages, only: [:index, :destroy, :create, :update, :edit]
  resources :request_tasks, only: [:index, :edit, :update]
  resources :tasks, only: [:index, :create, :destroy, :update]
  resources :employees, only: [:index, :create, :destroy, :edit, :update]
  resources :message_tasks, only: [:index]
  resources :attributes, only: [:index, :create, :destroy, :update]

  root  'static_pages#home'
  match '/help',  to: 'static_pages#help',       via: 'get'

  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'

  post 'messages_for_request' => 'requests#messages_for_request', :as => :messages_for_request
  post 'request_group_destroy' => 'requests#request_group_destroy', :as => :request_group_destroy
  post 'employee_group_destroy' => 'employees#employee_group_destroy', :as => :employee_group_destroy
  post 'message_group_destroy' => 'messages#message_group_destroy', :as => :message_group_destroy
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
