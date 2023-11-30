# frozen_string_literal: true

# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
    get '/login' => 'login#login', :as => :login
    get '/login/google', to: redirect('auth/google_oauth2'), as: :google_login
    get '/login/github', to: redirect('auth/github'), as: :github_login
    get '/auth/google_oauth2/callback', to: 'login#google_oauth2', as: :google_oauth2_callback
    get '/auth/github/callback', to: 'login#github', as: :github_callback
    get '/logout' => 'login#logout', :as => :logout
    get '/user/profile', to: 'user#profile', as: :user_profile

    root to: 'map#index', as: 'root'
    get '/state/:state_symbol' => 'map#state', :as => :state_map
    get '/state/:state_symbol/county/:std_fips_code' => 'map#county', :as => :county
    get '/ajax/state/:state_symbol' => 'ajax#counties'

    # Routes for Events
    resources :events, only: %i[index show]
    get '/my_events/new' => 'my_events#new', :as => :new_my_event
    match '/my_events/new', to: 'my_events#create', via: [:post]
    get '/my_events/:id' => 'my_events#edit', :as => :edit_my_event
    match '/my_events/:id', to: 'my_events#update', via: %i[put patch]
    match '/my_events/:id', to: 'my_events#destroy', via: [:delete]

    # Routes for Representatives
    resources :representatives, only: [:index]
    resources :representatives do
        resources :news_items, only: %i[index show]
        # get '/representatives/:representative_id/my_news_item/new' => 'my_news_items#select_rep_issue', 
        #                                                            => :select_rep_issue #v3
        get '/representatives/:representative_id/my_news_item/new' => 'my_news_items#new', 
            :as                                                        => :new #v1
        # get '/representatives/:representative_id/my_news_item/new/search' => 'my_news_items#search',
        #     :as                                                        => :search #v3
        post '/representatives/:representative_id/my_news_item/new' => 'my_news_items#search',
        :as                                                        => :search #v1
        get '/representatives/:representative_id/my_news_item/new/top_articles' => 'my_news_items#top_articles',
            :as                                                        => :top_articles #v1
        post '/representatives/:representative_id/my_news_item/new/top_articles' => 'my_news_items#rate_article',
            :as                                                        => :rate_article #v1
        #post '/representatives/:representative_id/my_news_item', to: 'my_news_items#create' 
    
        # get 'my_news_item/new', to: 'my_news_items#select_rep_issue', as: :select_rep_issue 
        # get 'my_news_item/new/top_articles', to: 'my_news_items#top_articles', as: :top_articles #v3
        # get 'my_news_item/new/continue', to: 'my_news_items#new_rep_issue', as: :new_rep_issue #v3
        # post 'my_news_item', to: 'my_news_items#create' #v3
  
        # get '/representatives/:representative_id/my_news_item/new' => 'my_news_items#new',
        #     :as                                                    => :new_my_news_item #v3
        #match '/representatives/:representative_id/my_news_item/new', to:  'my_news_items#create',
        #                                                              via: [:post] #v3
        # get '/representatives/:representative_id/my_news_item/:id' => 'my_news_items#edit',
        #     :as                                                    => :edit_my_news_item #v2
        # match '/representatives/:representative_id/my_news_item/:id', to:  'my_news_items#update',
        #                                                               via: %i[put patch] #v3
        # match '/representatives/:representative_id/my_news_item/:id', to:  'my_news_items#destroy',
        #                                                               via: [:delete] #v2
    end
    get '/search/(:address)' => 'search#search', :as => 'search_representatives'
end
