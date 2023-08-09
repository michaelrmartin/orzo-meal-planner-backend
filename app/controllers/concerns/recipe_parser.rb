module RecipeParser
  extend ActiveSupport::Concern

  def parse_recipe(parsed_data)
    raw_recipe = nil

    article = parsed_data["@graph"].find { |item| item["@type"] == "Article" }
    
    if article
      title = article["headline"]
      chef = article["author"]["name"]
      description = article["description"]
      
      recipe = parsed_data["@graph"].find { |item| item["@type"] == "Recipe" }

      if recipe
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
