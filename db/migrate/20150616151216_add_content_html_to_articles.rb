class AddContentHtmlToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :content_html, :text
  end
end
