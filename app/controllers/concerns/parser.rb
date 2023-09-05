module Parser  
  extend ActiveSupport::Concern

  def get_schema(doc)

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




end