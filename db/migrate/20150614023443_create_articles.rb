class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :category
      t.string :title
      t.string :description
      t.string :content
      t.string :link
      t.timestamps null: false
    end
    add_index :articles, :category
  end
end
