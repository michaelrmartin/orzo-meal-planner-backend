class ChangeTimesInRecipes < ActiveRecord::Migration[7.0]
  def change
    change_column :recipes, :prep_time, :string
  end
end
