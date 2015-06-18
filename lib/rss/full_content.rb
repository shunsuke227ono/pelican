require 'open-uri'
module FullContent
  def self.article_body(link)
    case
    when link.include?("livedoor")
      Nokogiri::HTML(open(link)).at("[@itemprop='articleBody']").inner_text
    when link.include?("rdsig.yahoo") || link.include?("zasshi.news.yahoo")
      Nokogiri::HTML(open(link)).css("p.ynDetailText").inner_text
    when link.include?("entabe")
      Nokogiri::HTML(open(link)).css("div.article-body").inner_text
    when link.include?("mery")
      Nokogiri::HTML(open(link)).at("[@itmprop='articleBody']").inner_text
    when link.include?("spotlight")
      Nokogiri::HTML(open(link)).at("[@itemprop='articleBody']").inner_text
    end
  end
  def self.img_and_article_body(link)
    # livedoorのみ
    res = {}
    page = Nokogiri::HTML(open(link))
    res[:article_body] = page.at("[@itemprop='articleBody']").inner_text
    res[:img] = page.at("[@itemprop='image']").attr('src') if page.at("[@itemprop='image']").present?
    res
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
