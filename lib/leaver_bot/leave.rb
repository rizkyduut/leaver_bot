class LeaverBot::Leave
  LEAVE_TYPE_KEY = 'leave_type'.freeze

  def self.add(username, duration, type)
    duration.times do |d|
      key = generate_key(Date.today.next_day(d))

      $redis.sadd(key, username)
      $redis.expire(key, 172800) # 2 days
      $redis.hset(LEAVE_TYPE_KEY, username, type)
    end
  end

  def self.check(username)
    key = generate_key(Date.today)

    return nil unless $redis.sismember(key, username)

    if $redis.hget(LEAVE_TYPE_KEY, username) == 'leave'
      "#{username} - cuti"
    elsif $redis.hget(LEAVE_TYPE_KEY, username) == 'remote'
      "@#{username} - remote"
    else
      nil
    end
  end

  def self.remove(username, duration)
    duration.times do |d|
      key = generate_key(Date.today.next_day(d))

      $redis.srem(key, username)
      $redis.hdel(LEAVE_TYPE_KEY, username)
    end
  end

  def self.delete(key)
    $redis.del(key)
  end

  def self.key
    $redis.keys('*').join(", ")
  end

  def self.cache(key)
    $redis.smembers(key).join(", ")
  end

  def self.cache_type(username)
    $redis.hget(LEAVE_TYPE_KEY, username)
  end

  private

  def self.generate_key(date)
    date.strftime("%Y%m%d")
  end
end
