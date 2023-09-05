class CreateInstructions < ActiveRecord::Migration[7.0]
  def change
    create_table :instructions do |t|
      t.integer :recipe_id
      t.integer :step_number
      t.text :step

      t.timestamps
    end
  end
end
