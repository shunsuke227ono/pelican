namespace :rss do
  desc "get rss basic information and store it to db"
  task :get_info => :environment do
    ActiveRecord::Base.transaction do
      Settings.livedoor.full.each do |key_and_url|
        key = key_and_url[0]
        url = key_and_url[1]
        feed = Feedjira::Feed.fetch_and_parse
      end
    end
  end
end
