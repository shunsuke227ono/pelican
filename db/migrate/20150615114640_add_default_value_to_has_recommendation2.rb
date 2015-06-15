class AddDefaultValueToHasRecommendation2 < ActiveRecord::Migration
  def change
    change_column :articles, :has_recommendation, :boolean, :default => false
  end
end
