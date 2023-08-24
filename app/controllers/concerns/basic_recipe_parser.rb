module BasicRecipeParser   
  extend ActiveSupport::Concern
  
  def parse_basic_recipe(doc)
    
    raw_recipe = nil

    json = doc.css('script[type="application/ld+json"]')
    parsed_data = JSON.parse(json.text)

    parsed_data.class != Array ? parsed_data = [parsed_data] : parsed_data = parsed_data

    recipe = parsed_data.find{|item| item["@type"] == "Recipe" }

    title = recipe["name"]
    chef = recipe["author"]["name"]
    description = recipe["description"].gsub(/[^0-9A-Za-z\p{Punct}\s]/, ' ')

    images = recipe["image"]
    ingredients = recipe["recipeIngredient"]
    
    if recipe["recipeInstructions"].length == 1
      instructions = recipe["recipeInstructions"][0]["text"].split("&nbsp;")
      instructions = instructions.map { |instruction| instruction.sub(/^\d+\.\s*/, "").strip }.reject(&:empty?)
    else
      instructions = recipe["recipeInstructions"].map { |step| step["text"] }
    end
     
    cleaned_ingredients = ingredients.map do |ingredient|
      ingredient.gsub(/[^0-9A-Za-z\p{Punct}\s]/, ' ')
    end
    
    cleaned_instructions = instructions.map do |step|
      step.gsub(/[^0-9A-Za-z\p{Punct}\s]/, ' ')
    end
        
    raw_recipe = {
      "title" => title,
      "chef" => chef,
      "images" => images,
      "description" => description,
      "ingredients" => cleaned_ingredients,
      "instructions" => cleaned_instructions,
    }

    raw_recipe

  end



end