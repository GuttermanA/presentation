Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/manufacturing_process', to: 'logs#manufacturing_process'
  get '/component_stats', to: 'logs#component_stats'
  get '/location_stats', to: 'logs#location_stats'
  resources :logs, only: [:index]
end
