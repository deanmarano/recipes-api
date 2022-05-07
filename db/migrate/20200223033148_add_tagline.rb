class AddTagline < ActiveRecord::Migration[5.2]
  def change
    add_column :recipes, :tagline, :string
  end
end
