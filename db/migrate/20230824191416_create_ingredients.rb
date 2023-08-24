class CreateIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :ingredients do |t|
      t.integer :recipe_id
      t.decimal :quantity
      t.string :name
      t.string :unit_of_measure
      t.string :description

      t.timestamps
    end
  end
end
