set :output, 'log/cron_log.log'
set :environment, :production

every :day, :at => '2:30pm' do
  rake "rss:get_livedoor"
end
every :day, :at => '3:00pm' do
  rake "rss:get_similar_dom"
end
every :day, :at => '3:15pm' do
  rake "similarity:get_similar_articles_dom"
end
every :day, :at => '3:30pm' do
  rake "rss:get_similar_int"
end
every :day, :at => '3:45pm' do
  rake "similarity:get_similar_articles_int"
end
every :day, :at => '4:00pm' do
  rake "rss:get_similar_eco"
end
every :day, :at => '4:15pm' do
  rake "similarity:get_similar_articles_eco"
end
every :day, :at => '4:30pm' do
  rake "rss:get_similar_ent"
end
every :day, :at => '4:45pm' do
  rake "similarity:get_similar_articles_ent"
end
every :day, :at => '5:00pm' do
  rake "rss:get_similar_spo"
end
every :day, :at => '5:15pm' do
  rake "similarity:get_similar_articles_spo"
end
every :day, :at => '5:30pm' do
  rake "rss:get_similar_mov"
end
every :day, :at => '5:45pm' do
  rake "similarity:get_similar_articles_mov"
end
every :day, :at => '6:00pm' do
  rake "rss:get_similar_gourmet"
end
every :day, :at => '6:15pm' do
  rake "similarity:get_similar_articles_gourmet"
end
every :day, :at => '6:30pm' do
  rake "rss:get_similar_love"
end
every :day, :at => '6:45pm' do
  rake "similarity:get_similar_articles_love"
end
every :day, :at => '7:00pm' do
  rake "rss:get_similar_trend"
end
every :day, :at => '7:15pm' do
  rake "similarity:get_similar_articles_trend"
end
every :day, :at => '7:30pm' do
  rake "similarity:get_similar_articles_top"
end
