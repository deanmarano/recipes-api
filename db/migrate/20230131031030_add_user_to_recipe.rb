class AddUserToRecipe < ActiveRecord::Migration[7.0]
  def change
    add_reference :recipes, :user, index: true, foreign_key: true
  end
end