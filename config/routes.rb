Rails.application.routes.draw do
  
  ### Recipes
  post "/fetch_recipe", to: "recipes#fetch_recipe"
  
  resources :recipes

  ### Ingredients
  resources :ingredients, only: %i[index show]

  ### Instructions
  resources :instructions, only: %i[index show]

end
