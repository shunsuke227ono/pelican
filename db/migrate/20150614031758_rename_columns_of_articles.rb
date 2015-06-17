class RenameColumnsOfArticles < ActiveRecord::Migration
  def change
    rename_column :articles, :link, :url
    rename_column :articles, :description, :summary
  end
end
