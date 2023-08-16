module YoastRecipeParser
  extend ActiveSupport::Concern

  def parse_yoast_recipe(doc)
    raw_recipe = nil

    json = doc.css('script[type="application/ld+json"]')
    parsed_data = JSON.parse(json.text)

    article = parsed_data["@graph"].find { |item| item["@type"] == "Article" }

    if article
      title = article["headline"]
      chef = article["author"]["name"]
      
      recipe = parsed_data["@graph"].find { |item| item["@type"] == "Recipe" }
      
      if recipe
        description = recipe["description"]
        images = recipe["image"]
        ingredients = recipe["recipeIngredient"]
        instructions = recipe["recipeInstructions"].map { |step| step["text"] }
        
        cleaned_instructions = instructions.map do |step|
          step.gsub(/[^0-9A-Za-z\p{Punct}\s]/, ' ')
        end
        
        raw_recipe = {
          "title" => title,
          "chef" => chef,
          "images" => images,
          "description" => description,
          "ingredients" => ingredients,
          "instructions" => cleaned_instructions,
        }
      end
    end

    raw_recipe

  end
end
