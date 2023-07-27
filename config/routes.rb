Rails.application.routes.draw do
  
  ### Recipes
  post "/fetch_recipe", to: "recipes#fetch_recipe"

end
