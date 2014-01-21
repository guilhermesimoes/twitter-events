TwitterEvents::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'pages#dashboard'

  resources :classifications, :only => [:new, :create]

  resources :tweets, :only => :index

  resources :events, :only => :show

  get 'tweets/stream' => 'tweets#stream'
end
