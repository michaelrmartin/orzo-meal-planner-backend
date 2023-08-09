class RecipesController < ApplicationController

  def fetch_recipe

    url = params[:url]
    html = URI.open(url)
    doc = Nokogiri::HTML(html)
    json = doc.css('script[type="application/ld+json"]')
    parsed = JSON.parse(json.text)
    
    article = parsed["@graph"].find { |item| item["@type"] == "Article" }

    if article
      title = article["headline"]
      chef = article["author"]["name"]
      description = article["description"]
    
      
      recipe = parsed["@graph"].find { |item| item["@type"] == "Recipe" }
    
      if recipe
        images = recipe["image"]
        ingredients = recipe["recipeIngredient"]
        instructions = recipe["recipeInstructions"].map { |step| step["text"] }

        cleaned_instructions = instructions.map do |step|
          step.gsub(/[^0-9A-Za-z\p{Punct}\s]/, '')
        end

      else
        images = []
        ingredients = []
        cleaned_instructions = []
      end

      raw_recipe = {
        "title" => title,
        "chef" => chef,
        "images" => images,
        "description" => description,
        "ingredients" => ingredients,
        "instructions" => cleaned_instructions,
        "url" => url
      }

    end

    render json: {raw_recipe: raw_recipe }

  end

end
