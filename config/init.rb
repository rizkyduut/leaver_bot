$telegram_bot_token = ENV['BOT_TOKEN']
redis = Redis.new(thread_safe: true)
$redis = Redis::Namespace.new(:leaver_bot, redis: redis)

$super_admin_username = ENV['SUPER_ADMIN_USERNAME']
$bot_username = ENV['BOT_USERNAME']
