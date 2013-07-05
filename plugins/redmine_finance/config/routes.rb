# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resources :accounts
resources :operations do
  collection do
      get :bulk_edit, :context_menu, :auto_complete
      delete :bulk_destroy
  end
end
resources :operation_categories
resources :operation_comments, :only => [:create, :destroy]
resources :operation_invoices, :only => [:create, :destroy]
resources :operation_relations, :only => [:create, :destroy]

resources :operation_imports, :only => [:new, :create]

resources :projects do
  resources :operations
end

resources :projects do
  resources :accounts
end
