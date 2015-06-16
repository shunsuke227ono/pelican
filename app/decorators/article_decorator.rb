class ArticleDecorator < Draper::Decorator
  def short_heading
    return object.summary.truncate(80) if object.summary.present?
    return object.content.truncate(80)
  end
  def long_heading
    return object.summary.truncate(160) if object.summary.present?
    return object.content.truncate(160)
  end
end
