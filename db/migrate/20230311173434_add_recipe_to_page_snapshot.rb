class AddRecipeToPageSnapshot < ActiveRecord::Migration[7.0]
  def change
    add_reference :page_snapshots, :recipe
  end
end
