class AddMultipleQuantitiesToIngredients < ActiveRecord::Migration[7.0]
  def change
    rename_column :ingredients, :quantity, :quantity1
    add_column :ingredients, :quantity2, :decimal
  end
end
