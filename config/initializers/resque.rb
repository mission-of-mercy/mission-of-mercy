$redis = Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'])
Resque.redis = $redis
