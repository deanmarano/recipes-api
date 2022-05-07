class CreatePageVisits < ActiveRecord::Migration[5.2]
  def change
    create_table :page_visits do |t|
      t.string :url
      t.datetime :accessed_at
      t.string :html

      t.timestamps
    end
  end
end
