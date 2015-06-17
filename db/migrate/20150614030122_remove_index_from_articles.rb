class RemoveIndexFromArticles < ActiveRecord::Migration
  def change
    remove_index :articles, :category
  end
end
