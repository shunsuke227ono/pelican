class RecommendedArticle < ActiveRecord::Base
  belongs_to :article
  belongs_to :similar_article
end

