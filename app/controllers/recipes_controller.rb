class RecipesController < ApplicationController
  include RecipeParser

  def fetch_recipe

    url = params[:url]
    html = URI.open(url)
    doc = Nokogiri::HTML(html)
    json = doc.css('script[type="application/ld+json"]')
    parsed = JSON.parse(json.text)
    
    raw_recipe = parse_recipe(parsed)

    render json: {raw_recipe: raw_recipe }

  end

end
