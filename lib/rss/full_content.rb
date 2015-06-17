require 'open-uri'
module FullContent
  def self.article_body(link, resource_name)
    case resource_name
    when :livedoor
      Nokogiri::HTML(open(link)).at("[@itemprop='articleBody']").inner_text
    when :yahoo
      Nokogiri::HTML(open(link)).css("p.ynDetailText").inner_text
    end
  end
  def self.img_and_article_body_and_html(link)
    # livedoorのみ
    res = {}
    page = Nokogiri::HTML(open(link))
    res[:article_body] = page.at("[@itemprop='articleBody']").inner_text
    res[:article_body_html] = page.css("div.articleBody").to_html
    res[:img] = page.at("[@itemprop='image']").attr('src') if page.at("[@itemprop='image']").present?
    res
  end
end
