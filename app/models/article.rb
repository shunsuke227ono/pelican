class Article < ActiveRecord::Base
  has_many :recommended_articles
  has_many :similar_articles, through: :recommended_articles
  enum category: {
    top: 1,
    dom: 2,
    int: 3,
    eco: 4,
    ent: 5,
    spo: 6,
    mov: 7,
    gourmet: 8,
    love: 9,
    trend: 10
  }

  scope :without_recommendation, -> { where(has_recommendation: false) }
end
