class ArticleDecorator < Draper::Decorator
  def short_heading
    return object.summary.truncate(number_of_words(80)) if object.summary.present?
    return object.content.truncate(number_of_words(80))
  end
  def long_heading
    return object.summary.truncate(number_of_words(160)) if object.summary.present?
    return object.content.truncate(number_of_words(160))
  end
  private
  def long_title?
    object.title.size > 25
  end
  def number_of_words(default_number)
    default_number * 3/4 if long_title?
    default_number
  end
end
