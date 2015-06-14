class ChangeColumnTypeOfArticle < ActiveRecord::Migration
  def change
    change_column :articles, :content, :text
    change_column :articles, :summary, :text
  end
end
