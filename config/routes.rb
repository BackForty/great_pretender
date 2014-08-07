GreatPretender::Engine.routes.draw do
  root to: 'great_pretender/mockups#index', as: :mockups
  get '*id', to: 'great_pretender/mockups#show', as: :mockup
end
