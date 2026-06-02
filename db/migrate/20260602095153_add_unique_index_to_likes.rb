class AddUniqueIndexToLikes < ActiveRecord::Migration[8.1]
  def change
    add_index :likes, [:user_id, :post_id], unique: true
  end
end
