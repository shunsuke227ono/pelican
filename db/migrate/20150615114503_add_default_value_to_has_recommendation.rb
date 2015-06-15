class AddDefaultValueToHasRecommendation < ActiveRecord::Migration
  def change
    change_column :articles, :has_recommendation, :boolean, :deafault => false
  end
end
