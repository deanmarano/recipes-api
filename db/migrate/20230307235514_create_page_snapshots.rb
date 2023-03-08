class CreatePageSnapshots < ActiveRecord::Migration[7.0]
  def change
    create_table :page_snapshots do |t|
      t.belongs_to :user
      t.string :url
      t.string :html
      t.string :mhtml
      t.string :mobile_snapshot_base64
      t.string :desktop_snapshot_base64
      t.integer :duration
      t.datetime :started_at
      t.datetime :finished_at

      t.timestamps
    end
  end
end
