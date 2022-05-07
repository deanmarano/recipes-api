class CreateRecipes < ActiveRecord::Migration[5.2]
  def change
    create_table :recipes do |t|
      t.string :slug
      t.string :name
      t.string :source
      t.string :status
      t.jsonb :ingredients
      t.jsonb :instructions
      t.string :sha
      t.references :parent

      t.timestamps
    end
  end
end
