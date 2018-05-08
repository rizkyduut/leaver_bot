module LeaverBot
  class Leave
    LEAVE_TYPE_KEY = 'leave_type'.freeze

    def self.add(username, duration, type, date = Date.today)
      duration.times do |d|
        day      = date.next_day(d)
        expireat = day.next_day(2).to_time.to_i # 2 days from leave day
        key      = generate_key(day)

        $redis.hset(key, username, type)
        $redis.expireat(key, expireat)
      end
    end

    def self.my_status(username)
      today = Date.today
      end_of_month = today.end_of_month

      result = []
      (today..end_of_month).each do |dday|
        key = generate_key(dday)

        status = $redis.hget(key, username)

        if $redis.hexists(key, username) && status
          result << [key, status]
        end
      end

      result
    end

    def self.check_status(username, date = Date.today)
      key = generate_key(date)

      return nil unless $redis.hget(key, username)

      leave_type = $redis.hget(key, username)

      "#{leave_type == 'remote' ? "@" : ""}#{username} - #{leave_type.titlecase}"
    end

    def self.check_leave(username)
      key = generate_key(Date.today)

      $redis.hget(key, username)
    end

    def self.check_status_by_month(group, month = Date.today.month)
      duration = (Date.today.end_of_month - Date.today).to_i

      results = []

      duration.times do |d|
        date = Date.today.next_day(d)
        key = generate_key(date)

        if $redis.exists(key)
          temp = []
          group.user_list.each do |username|
            if $redis.hexists(key, username)
              temp.push check_status(username, date)
            end
          end

          temp.unshift("\n#{date.strftime("%A, %d %B %Y")}\n==========") unless temp.empty?
          results.concat temp
        end
      end

      results
    end

    def self.remove(username, duration, date = Date.today)
      duration.times do |d|
        key = generate_key(date.next_day(d))

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
