class CreateBonAppetitRecipes < ActiveRecord::Migration[5.2]
  def change
    add_column :recipes, :cover_image_url, :string
    add_column :recipes, :cover_image_alt, :string
    add_column :recipes, :cover_image_caption, :string
    add_column :recipes, :servings, :string
  end
end
