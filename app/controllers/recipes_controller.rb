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
    pp params
    recipe = Recipe.new(
      user_id: 1,
      title: params[:title],
      chef: params[:chef],
      description: params[:description],
      image_url: params[:image],
      cook_time: params[:cook_time],
      prep_time: params[:prep_time]
    )
  
    if recipe.save
      @recipe = recipe  
      render json: recipe.as_json
    else
      render json: {errors: recipe.errors.full_messages}
    end
  
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
