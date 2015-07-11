Etsydemo::Application.routes.draw do

  

  resources :comments

  resources :blogs do
    resources :replies, except: [:show, :index]
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :subjects

  resources :tutorships do
    collection do
      put :accept_tutorship, as: 'accept'
    end
  end

  match '/contacts', to: 'contacts#new', via: 'get'
  resources "contacts", only: [:new, :create]

  resources :questions do
    collection do
      post "create_question_comment" do
        post "create_question_comment_reply"
      end
    end
  end


  
     
    resources :messages 

    resources :conversations do
      member do
        post :reply
        post 'trash'
      end
    end
    
    devise_for :users, :path_prefix => 'account', :controllers => { :registrations => "registrations" }
   
    resources :tutor_profiles do 
      get :autocomplete_tutor_profile_teaching_subject, :on => :collection
      collection do 
        get 'search'
        get 'reference'
        get 'invite_for_review'
        post 'send_invitation_for_review'
        get 'send_user_specific_request_for_review'
      end
      resources :tuitions do
        collection do
          get 'book_tuition'
          get 'payment_detail'
          post 'perform_transaction'
        end
      end
      resources :reviews, except: [:show, :index]
    end

    resources :new_tutor_profiles do
      collection do
        post 'update_tutor_profile'
      end
    end
  
    resources :enquiries 
    
    resources :users
  get "pages/about"
  get 'mytuition' => "tuitions#mytuition"
  get "pages/inbox"
  get "pages/how_it_works"
  get "pages/require_sign_in"

  
  post "pages/get_town_from_country_for_step_1"
  post "pages/get_country_set_city"
  post "pages/get_city_set_town"
  
  get "admin/notify_users"
  post "admin/send_mail_to_users"
  get "admin/run_script"

  root 'pages#index'
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
