class CreateMeals < ActiveRecord::Migration[5.2]
  def change
    create_table :meals do |t|
      t.references :recipe, foreign_key: true
      t.string :status
      t.integer :rating
      t.string :notes

      t.timestamps
    end
  end
end
