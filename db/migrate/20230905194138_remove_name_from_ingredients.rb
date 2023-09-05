class RemoveNameFromIngredients < ActiveRecord::Migration[7.0]
  def change
    remove_column :ingredients, :name, :string
  end
end
