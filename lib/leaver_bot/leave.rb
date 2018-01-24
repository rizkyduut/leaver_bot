class LeaverBot::Leave
  LEAVE_KEY = 'LEAVE-'
  REMOTE_KEY = 'REMOTE-'

  def self.add(message, duration, type)
    duration.times do |d|
      key = generate_key(Date.today.next_day(d), type)
      expireat = Date.today.next_day(2).to_time.to_i

      $redis.sadd(key, message.from.username)
      $redis.expireat(key, expireat)
    end
  end

  def self.check(username)
    leave_key = generate_key(Date.today, 'leave')
    remote_key = generate_key(Date.today, 'remote')

    if $redis.sismember(leave_key, username)
      'Cuti hari ini'
    elsif $redis.sismember(remote_key, username)
      'Remote hari ini'
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
