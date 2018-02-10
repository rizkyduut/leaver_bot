class LeaverBot::InputProcessor
  include SuckerPunch::Job
  workers 5

  attr_accessor :bot

  def perform(message, bot)
    @bot = bot

    return unless message

    # ignores edited messages
    return if message.edit_date

    # ignores other type of messages
    return unless message.text

    text = message.text.sub("@#{$bot_username}", '')

    #admin flow
    if text.starts_with?('/sudo ') && (super_admin?(message) || admin?(message))
      if text =~ /reset +(.+)$/
        key = $1
        LeaverBot::Leave.delete(key)
        reply(message, 'Berhasil menghapus cache')
      elsif text =~ /cache +(.+)$/
        key = $1
        reply(message, LeaverBot::Leave.cache(key))
      elsif text =~ /cachetype +(.+)$/
        username = $1
        reply(message, LeaverBot::Leave.cache_type(username))
      elsif text =~ /keys/
        reply(message, LeaverBot::Leave.key)
      end
    end

    #normal flow
    if text =~ /^\/add +((?:@?[A-Za-z0-9_]{5,} *)+) +(.+)$/
      group_name = $2
      usernames = $1.split.map{ |u| u.sub('@', '') }
      if group = registered_group?(group_name)
        replies = {}
        usernames.each do |username|
          replies[username] = register_user(username, group)
        end

        reply(message, replies.map { |username, rep| "@#{username}: #{rep}" }.join("\n"))
      else
        reply(message, 'Group tidak ditemukan')
      end
    elsif !in_private?(message)
      if text =~ /^\/add_group +(.+)$/
        reply(message, register_group(message, $1))
      elsif text =~ /^\/status/
        if Date.today.saturday? || Date.today.sunday?
          reply(message, 'Liburan gih sana')
        elsif group = get_group(message.chat.id)
          if usernames = group.user_list
            replies = []
            usernames.each do |username|
              replies.push(check_leave(username))
            end

            reply_status(message, replies)
          else
            reply(message, 'Belum ada user yang didaftarkan dalam group ini')
          end
        else
          reply(message, 'Group ini belum didaftarkan')
        end
      elsif text =~ /^\/help/
        reply(message, 'Japri aja ya')
      end
    elsif in_private?(message)
      if text =~ /^\/help/
        reply(message, LeaverBot::Message.help_text)
      elsif text == '/leave'
        reply(message, LeaverBot::Message.leave_text('leave'))
      elsif text == '/remote'
        reply(message, LeaverBot::Message.leave_text('remote'))
      elsif text == '/reset'
        reply(message, LeaverBot::Message.reset_text)
      elsif text == '/reminder'
        reply(message, LeaverBot::Message.reminder_text)
      elsif registered_user?(message.from)
        if text =~ /^\/leave +([0-9]+)$/
          days = $1.to_i
          return if days <= 0
          add_leave(message, days, 'leave')

          if days == 1
            reply(message, 'Cuti untuk hari ini berhasil didaftarkan')
          else
            reply(message, "Cuti sampai tanggal #{Date.today.next_day(days-1).strftime("%d-%m-%Y")} berhasil didaftarkan")
          end
        elsif text =~ /^\/remote +([0-9]+)$/
          days = $1.to_i
          return if days <= 0
          add_leave(message, days, 'remote')

          if days == 1
            reply(message, 'Remote untuk hari ini berhasil didaftarkan')
          else
            reply(message, "Remote sampai tanggal #{Date.today.next_day(days-1).strftime("%d-%m-%Y")} berhasil didaftarkan")
          end
        elsif text =~ /^\/reset +([0-9]+)$/
          days = $1.to_i
          return if days <= 0
          remove_leave(message, days)

          reply(message, "Data cuti/remote sampai tanggal #{Date.today.next_day(days-1).strftime("%d-%m-%Y")} berhasil dihapus")
        elsif text =~ /^\/status/
          reply(message, 'COMING SOON')
        end
      elsif !registered_user?(message.from)
        if text =~ /^\/status/
          reply(message, LeaverBot::Message.status_text)
        end
      end
    end
  end

  private

  def super_admin?(message)
    message.from.username == $super_admin_username
  end

  def in_private?(message)
    message.chat.type == 'private'
  end

  def register_group(message, group_name)
    begin
      LeaverBot::Group.create!(group_id: message.chat.id, name: group_name.downcase)
      'Group ini berhasil didaftarkan dalam sistem'
    rescue
      'Group ini sudah terdaftar sebelumnya'
    end
  end

  def registered_group?(group_name)
    LeaverBot::Group.find_by(name: /^#{group_name}$/i)
  end

  def get_group(group_id)
    LeaverBot::Group.find_by(group_id: group_id)
  end

  def register_user(username, group)
    if LeaverBot::User.where(username: /^#{username}$/i, group_list: group.name).first
      "Sudah terdaftar di group #{group.name} sebelumnya"
    elsif user = LeaverBot::User.where(username: /^#{username}$/i).first
      user.add_to_set(group_list: group.name)
      group.add_to_set(user_list: username)
      'Berhasil didaftarkan ke dalam group'
    else
      new_user = LeaverBot::User.create!(username: username, group_list: [group.name])
      group.add_to_set(user_list: username)
      'Berhasil didaftarkan dalam sistem'
    end
  end

  def registered_user?(tg_user)
    LeaverBot::User.get(tg_user)
  end

  def add_leave(message, duration, type)
    LeaverBot::Leave.add(message.from.username, duration, type)
  end

  def check_leave(username)
    LeaverBot::Leave.check(username)
  end

  def remove_leave(message, duration)
    LeaverBot::Leave.remove(message.from.username, duration)
  end

  def reply(message, text)
    send(chat_id: message.chat.id, text: text, reply_to_message_id: message.message_id)
  end

  def reply_status(message, replies)
    unless replies.all?(&:nil?)
      replies.unshift('Berikut daftar yang tidak hadir hari ini:')
      reply(message, replies.compact.join("\n"))
    else
      reply(message, 'Semua hadir hari ini. Yeay!')
    end
  end

  def send(options = {})
    LeaverBot::MessageSender.perform_async(@bot, options)
  end
end
