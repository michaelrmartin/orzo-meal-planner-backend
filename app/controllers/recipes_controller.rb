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
        image = recipe["image"][0]
        ingredients = recipe["recipeIngredient"]
        instructions = recipe["recipeInstructions"].map { |step| step["text"] }
      else
        ingredients = []
        instructions = []
      end

      raw_recipe = {
        "title" => title,
        "chef" => chef,
        "image" => image,
        "description" => description,
        "ingredients" => ingredients,
        "instructions" => instructions,
        "url" => url
      }

    end

    render json: {raw_recipe: raw_recipe }

  end

end
