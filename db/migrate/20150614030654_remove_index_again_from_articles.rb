class RemoveIndexAgainFromArticles < ActiveRecord::Migration
  def change
    remove_index :articles, [:category, :link]
  end
end
