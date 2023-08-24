class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.integer :user_id
      t.string :title
      t.string :chef
      t.text :description
      t.string :image_url
      t.integer :prep_time
      t.integer :cook_time

      t.timestamps
    end
  end
end
