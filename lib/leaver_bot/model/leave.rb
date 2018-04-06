module LeaverBot
  class Leave
    LEAVE_TYPE_KEY = 'leave_type'.freeze

    def self.add(username, duration, type)
      duration.times do |d|
        day      = Date.today.next_day(d)
        expireat = day.next_day(2).to_time.to_i # 2 days from leave day
        key      = generate_key(day)

        $redis.sadd(key, username)
        $redis.expireat(key, expireat)
        $redis.hset(LEAVE_TYPE_KEY, username, type)
      end
    end

    def self.check_status(username)
      key = generate_key(Date.today)

      return nil unless $redis.sismember(key, username)

      if $redis.hget(LEAVE_TYPE_KEY, username) == 'cuti'
        "#{username} - cuti"
      elsif $redis.hget(LEAVE_TYPE_KEY, username) == 'sakit'
        "#{username} - sakit"
      elsif $redis.hget(LEAVE_TYPE_KEY, username) == 'remote'
        "@#{username} - remote"
      else
        nil
      end
    end

    def self.check_leave(username)
      key = generate_key(Date.today)

      $redis.sismember(key, username)
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
end
