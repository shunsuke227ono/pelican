class AddIndexAgainToArticles < ActiveRecord::Migration
  def change
    add_index :articles, [:category, :link], :unique => true
  end
end
