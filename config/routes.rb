Rails.application.routes.draw do
  mount LetsencryptPlugin::Engine, at: '/'

  constraints subdomain: "www" do
    get "/" => redirect { "https://coderwall.com" }
  end

  # This disables serving any web requests other then /assets out of CloudFront
  # match '*path', via: :all, to: 'pages#show', page: 'not_found',
  #   constraints: CloudfrontConstraint.new

  resources :jobs, only: [:index, :show, :new, :create]
  resources :subscriptions, controller: 'job_subscriptions', path: 'jobs/subscriptions', only: [:new, :create]

  root  'protips#home'
  get   '/p/trending'       => redirect("/trending", status: 302)
  get   '/p/popular'        => redirect("/popular",  status: 302)
  get   '/p/fresh'          => redirect("/fresh",    status: 302)
  get   '/gh'               => redirect("/trending", status: 302)

  get   '/trending(/:page)'       => 'protips#index', order_by: :score,        as: :trending
  get   '/popular(/:page)'        => 'protips#index', order_by: :views_count,  as: :popular
  get   '/fresh(/:page)'          => 'protips#index', order_by: :created_at,   as: :fresh
  get   '/t/:topic/popular(/:page)' => 'protips#index', order_by: :views_count, as: :popular_topic, constraints: { :topic => /.*/ }
  get   '/t/:topic/fresh(/:page)'   => 'protips#index', order_by: :created_at, as: :fresh_topic, constraints: { :topic => /.*/ }

  get    "/signin"     => "clearance/sessions#new",                as: :sign_in
  get    "/goodbye"    => "clearance/sessions#destroy",            as: :sign_out
  get    "/signup"     => "clearance/users#new",                   as: :sign_up
  get    '/faq'        => 'pages#show',          page: 'faq',      as: :faq
  get    '/tos'        => 'pages#show',          page: 'tos',      as: :tos
  get    '/privacy_policy' => 'pages#show',    page: 'privacy',  as: :privacy
  get    '/404'            => "pages#show",    page: 'not_found'
  get    '/500'            => "pages#show",    page: 'server_error'
  get    '/helloworld'     => "users#edit",    finish_signup: true, as: :finish_signup
  get    '/styleguide'     => "pages#show",    page: 'styleguide'
  get    '/delete_account' => 'users#show',    delete_account: true
  get    '/p/u/:username',     to: redirect("/%{username}/protips", status:302)
  get    '/twitter/:username', to: redirect("/404", status:302)
  get    '/github/:username',  to: redirect("/404", status:302)
  get    '/team/:slug'     => 'teams#show'
  get    '/sponsors' => 'sponsors#show', as: :sponsors

  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session,    controller: "clearance/sessions",  only: [:create]

  resources :users do
    get '/new', on: :collection, to: redirect('/signup')
    member do
      get '/endorsements' => 'users#show' #legacy url
      resources :likes, only: :index
    end
  end

  resources :users, controller: "clearance/users", only: [:create] do
    resources :pictures
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]
  end

  resources :comments do
    resources :likes, only: :create
    collection do
      get '/spam'      => 'comments#spam'
    end
  end

  if Rails.env.development?
    get 'impersonate' => 'users#impersonate', as: :impersonate_random
  end

  # deprecated
  get   '/welcome' => redirect("/", status: 301)
  get   '/p/t/:topic(/:page)' => redirect("/t/%{topic}/popular/%{page}", status: 301), defaults: { page: 1 }, constraints: { :topic => /.*/ }
  get   '/n/:topic(/:page)' => redirect("/t/%{topic}/popular/%{page}", status: 301), defaults: { page: 1 }, constraints: { :topic => /.*/ }
  get   '/p/t/:topic/popular(/:page)' => redirect("/t/%{topic}/popular/%{page}", status: 301), defaults: { page: 1 }, constraints: { :topic => /.*/ }
  get   '/p/t/:topic/fresh(/:page)'   => redirect("/t/%{topic}/fresh/%{page}", status: 301), defaults: { page: 1 }, constraints: { :topic => /.*/ }
  get   '/:topic/popular(/:page)' => redirect("/t/%{topic}/popular/%{page}", status: 301), defaults: { page: 1 }, constraints: { :topic => /.*/ }
  get   '/:topic/fresh(/:page)'   => redirect("/t/%{topic}/fresh/%{page}", status: 301), defaults: { page: 1 }, constraints: { :topic => /.*/ }
  #

  resources :protips, path: '/p' do
    resources :likes, only: :create
    resources :subscribers, only: [:create] do
      delete :destroy, on: :collection
    end
    collection do
      get '/spam'      => 'protips#spam'
      get '/:id/edit'  => 'protips#edit'  #this prevents next route from clobbering edit
      get '/:id/:slug' => 'protips#show', as: :slug
    end
    get 'mute/:signature' => 'subscribers#mute', as: :mute
    post '/mark_spam' => 'protips#mark_spam'
  end

  get '/:username'          => 'users#show',   as: :profile
  get '/:username/protips'  => 'users#show',   as: :profile_protips,  protips:  true
  get '/:username/comments' => 'users#show',   as: :profile_comments, comments: true
  get '/:username/impersonate' => 'users#impersonate', as: :impersonate

  resources :hooks, only: [] do
    collection do
      post 'sendgrid'
    end
  end

  match '*any', to: 'pages#show', page: 'not_found', via: [:get, :post] if Rails.env.production?
end
