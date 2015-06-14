require 'open-uri'
module FullContent
  def self.article_body(link)
    page = Nokogiri::HTML(open(link)).at("[@itemprop='articleBody']").inner_text
  end
end
