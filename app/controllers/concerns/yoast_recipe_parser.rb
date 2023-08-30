module YoastRecipeParser
  extend ActiveSupport::Concern

  def parse_yoast_recipe(doc)
    raw_recipe = nil

    json = doc.css('script[type="application/ld+json"]')
    parsed_data = JSON.parse(json.text)

    article = parsed_data["@graph"].find { |item| item["@type"] == "Article" }

    recipe = parsed_data["@graph"].find { |item| item["@type"] == "Recipe" }

    if article
      title = article["headline"]
      chef = article["author"]["name"]
    else 
      title = recipe["name"]
      chef = recipe["author"]
    end

    description = recipe["description"].gsub(/[^0-9A-Za-z\p{Punct}\s]/, ' ')

    if recipe["prepTime"]
      prep_time = extract_time_in_minutes(recipe["prepTime"])
    else
      prep_time = nil
    end
    
    if recipe["cookTime"]
      cook_time = extract_time_in_minutes(recipe["cookTime"])
    else
      cook_time = nil
    end

    image = recipe["image"][0]
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
      "prep_time" => prep_time,
      "cook_time" => cook_time,
      "image" => image,
      "description" => description,
      "ingredients" => cleaned_ingredients,
      "instructions" => cleaned_instructions,
      }

    raw_recipe

  end

  def extract_time_in_minutes(time_string)
    duration_match = time_string.match(/P(?:T(?:(\d*)H)?(?:(\d*)M)?)?/)
  
    hours = duration_match[1].to_i
    minutes = duration_match[2].to_i
  
    total_minutes = (hours * 60) + minutes
  end

end