class AddIsGroupHeaderToIngredients < ActiveRecord::Migration[7.0]
  def change
    add_column :ingredients, :is_group_header, :boolean
    add_column :ingredients, :unit_of_measure_id, :string 
  end
end
