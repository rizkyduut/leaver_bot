module LeaverBot
  class Leave
    LEAVE_TYPE_KEY = 'leave_type'.freeze

    def self.add(username, duration, type)
      duration.times do |d|
        day      = Date.today.next_day(d)
        expireat = day.next_day(2).to_time.to_i # 2 days from leave day
        key      = generate_key(day)

        $redis.hset(key, username, type)
        $redis.expireat(key, expireat)
      end
    end

    def self.check_status(username, date = Date.today)
      key = generate_key(date)

      return nil unless $redis.hget(key, username)

      leave_type = $redis.hget(key, username)

      "#{leave_type == 'remote' ? "@" : ""}#{username} - #{leave_type}"
    end

    def self.check_leave(username)
      key = generate_key(Date.today)

      $redis.hget(key, username)
    end

    def self.remove(username, duration)
      duration.times do |d|
        key = generate_key(Date.today.next_day(d))

        $redis.hdel(key, username)
      end
    end

    def self.delete(key)
      $redis.del(key)
    end

    def self.key
      $redis.keys('*').join(", ")
    end

    def self.cache(key)
      $redis.hkeys(key).join(", ")
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
