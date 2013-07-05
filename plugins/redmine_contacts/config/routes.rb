#custom routes for this plugin
  resources :contacts, :path_names => {:contacts_notes => 'notes'} do
    collection do
      get :bulk_edit, :context_menu, :edit_mails, :preview_email, :contacts_notes
      post :bulk_edit, :bulk_update, :send_mails
      delete :bulk_destroy
    end
  end
  
  resources :projects do 
    resources :contacts, :path_names => {:contacts_notes => 'notes'} do
      collection do 
        get :contacts_notes
      end
    end

  end
  
  resources :deals do
    collection do
      get :bulk_edit, :context_menu, :edit_mails, :preview_email
      post :bulk_edit, :bulk_update, :send_mails
      delete :bulk_destroy
    end
  end

  resources :projects do 
    resources :deals, :only => [:new, :create, :index]
  end

  resources :projects do 
    resources :contacts_queries, :only => [:new, :create]
  end  

  resources :contacts_queries, :except => [:show]

  resources :deal_statuses, :except => :show do
    collection do
      put :assing_to_project
    end
  end

  resources :notes

  match 'projects/:project_id/contacts/:contact_id/new_task' => 'contacts_tasks#new', :via => :post

  match 'contacts/:contact_id/duplicates' => 'contacts_duplicates#index'

  match 'projects/:project_id/deal_categories/new' => 'deal_categories#new'
 
  match 'projects/:project_id/sales_funnel'  => 'sales_funnel#index'
  match 'sales_funnel/:action' => 'sales_funnel#index'



  # match 'notes/:note_id' => 'notes#show', :via => :get, :as => "note"
  # match 'notes/show/:note_id' => 'notes#show', :via => :get
  # match 'notes/:note_id/edit' => 'notes#edit', :via => :get
  # match 'notes/:note_id/update' => 'notes#update', :via => :put
  # match 'notes/add_note' => 'notes#add_note'
  # match 'notes/destroy' => 'notes#destroy'
  
  match 'auto_completes/contact_tags' => 'auto_completes#contact_tags', :via => :get, :as => 'auto_complete_contact_tags'
  match 'auto_completes/contacts' => 'auto_completes#contacts', :via => :get, :as => 'auto_complete_contacts'
  match 'auto_completes/companies' => 'auto_completes#companies', :via => :get, :as => 'auto_complete_companies'
  
  match 'users/new_from_contact/:id' => 'users#new_from_contact', :via => :get
  match 'contacts_duplicates/:action' => 'contacts_duplicates'
  match 'contacts_duplicates/search' => 'contacts_duplicates#search', :via => :get, :as => 'contacts_duplicates_search'
  match 'contacts_projects/:action' => 'contacts_projects'
  match 'contacts_tags/:action' => 'contacts_tags'
  match 'contacts_tasks/:action' => 'contacts_tasks'
  match 'contacts_vcf/:action' => 'contacts_vcf'
  match 'deal_categories/:action' => 'deal_categories'
  match 'deal_contacts/:action' => 'deal_contacts'
  match 'deals_tasks/:action' => 'deals_tasks'
  match 'contacts_settings/:action' => 'contacts_settings'
  match 'contacts_mailer/:action' => 'contacts_mailer'
  match 'deals_tasks/:action' => 'deals_tasks'
  match 'attachments/contacts_thumbnail/:id(/:size)', :controller => 'attachments', :action => 'contacts_thumbnail', :id => /\d+/, :via => :get

    
