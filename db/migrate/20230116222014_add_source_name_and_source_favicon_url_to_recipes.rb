class AddSourceNameAndSourceFaviconUrlToRecipes < ActiveRecord::Migration[7.0]
  def change
    add_column :recipes, :source_name, :text
    add_column :recipes, :source_favicon_url, :text
  end
end
