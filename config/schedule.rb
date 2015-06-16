set :output, 'log/cron_log.log'
set :environment, :production

every :hour do
  rake "rss:get_livedoor"
  rake "rss:get_yahoo"
  rake "similarity:get_similar_articles"
end
