Etsydemo::Application.routes.draw do

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

  scope "(:locale)", locale: /en|ko|zh/ do
    
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
  end




  get "pages/about"
  get "pages/contact"

  get 'mytuition' => "tuitions#mytuition"
  get 'tutors' => "tutorships#tutors"
  get 'students' => "tutorships#students"

  get "pages/inbox"

  get "pages/resources"
  get "pages/personal_statements"
  get "pages/college_essays"
  get "pages/oxbridge_interview_questions"
  get "pages/suggested_readings"
  get "pages/admissions_facts"
  get "pages/writing_personal_statements"
  get "pages/admissions_test"
  get "pages/written_work"
  get "pages/oxbridge_interviews"
  get "pages/students_parents"
  get "pages/services_for_schools"
  get "pages/partners"
  get "pages/online_tuition"
  get "pages/how_it_works"
  get "pages/terms_and_conditions"
  get "pages/terms_and_conditions/for_tutors"
  get "pages/terms_and_conditions/for_students"
  get "pages/become_a_tutor"
  get "pages/referral_scheme"
  get "pages/tutor_policy"
  get "pages/free_consultation"
  get "pages/our_stars"

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
