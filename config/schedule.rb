set :output, 'log/cron_log.log'
set :environment, :production

every :hour do
  rake "rss:get_livedoor"
end

every :hour do
  rake "rss:get_yahoo_spo"
end

every :hour do
  rake "similarity:get_similar_articles"
end
