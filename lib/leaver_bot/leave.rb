class LeaverBot::Leave
  LEAVE_KEY = 'LEAVE-'
  REMOTE_KEY = 'REMOTE-'

  def self.add(message, duration, type)
    duration.times do |d|
      key = generate_key(Date.today.next_day(d), type)

      $redis.sadd(key, message.from.username)
      $redis.expire(key, 172800) # 2 days
    end
  end

  def self.check(username)
    leave_key = generate_key(Date.today, 'leave')
    remote_key = generate_key(Date.today, 'remote')

    if $redis.sismember(leave_key, username)
      "#{username} - cuti"
    elsif $redis.sismember(remote_key, username)
      "@#{username} - remote"
    else
      nil
    end
  end

  def self.remove(message, duration)
    duration.times do |d|
      leave_key = generate_key(Date.today.next_day(d), 'leave')
      remote_key = generate_key(Date.today.next_day(d), 'remote')

      $redis.srem(leave_key, message.from.username)
      $redis.srem(remote_key, message.from.username)
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

  private

  def self.generate_key(date, type)
    if type == 'leave'
      LEAVE_KEY + date.strftime("%Y%m%d")
    elsif type == 'remote'
      REMOTE_KEY + date.strftime("%Y%m%d")
    end
  end
end
