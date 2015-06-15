require 'open-uri'
module FullContent
  def self.article_body(link, resource_name)
    case resource_name
    when :livedoor
      page = Nokogiri::HTML(open(link)).at("[@itemprop='articleBody']").inner_text
    when :yahoo
      page = Nokogiri::HTML(open(link)).css("p.ynDetailText").inner_text
    end
  end
end
