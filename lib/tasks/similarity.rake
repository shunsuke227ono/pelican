namespace :similarity do
  desc "calculate similarity of articles and store it to livedoor article db"
  task :get_similarity => :environment do
    ActiveRecord::Base.transaction do
      # それぞれの記事を形態素のarrayに
      all_article_morpheme = []
      Article.each do |article|
            
      end
    end
  end
end
