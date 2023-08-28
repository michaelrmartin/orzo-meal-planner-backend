class RecipesController < ApplicationController
  include BasicRecipeParser
  include YoastRecipeParser


  def fetch_recipe

    url = params[:url]
    html = URI.open(url)
    doc = Nokogiri::HTML(html)


    if (doc.css('script[type*="application/ld+json"].yoast-schema-graph')).length > 0
      raw_recipe = parse_yoast_recipe(doc)
    else
      js = (doc.css('script[type*="application/ld+json"]'))
      if js.length == 1
        raw_recipe = parse_basic_recipe(doc)
      else
        render json: {message: "Invalid Schema"}
      end
    end

    render json: {raw_recipe: raw_recipe }

  end

  def create
    p params
    puts params
    pp params
    # recipe = Recipe.new(recipe_params)

    # if recipe.save
    #   @recipe = recipe  
      
      


    #   render json: recipe.as_json

    # else
    #   render json: {errors: recipe.errors.full_messages}
    # end

  end

  # def recipe_params
  #   params.require(:recipe).permit(
  #     :user_id,
  #     :title,
  #     :chef,
  #     :description,
  #     :image_url,
  #     :prep_time,
  #     :cook_time
  #   )
  # end

end
