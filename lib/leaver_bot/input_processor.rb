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

    if text =~ /^\/register_group +(.+)$/
      reply(message, register_group(message, $1))
    elsif text =~ /^\/register +((?:@?[A-Za-z0-9_]{5,} *)+) +(.+)$/
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
    elsif text =~ /^\/reset +(.+)$/
      key = $1
      LeaverBot::Leave.delete(key)
      reply(message, 'Berhasil menghapus cache')
    elsif text =~ /^\/cache +(.+)$/
      key = $1
      reply(message, LeaverBot::Leave.cache(key))
    elsif text == '/keys'
      reply(message, LeaverBot::Leave.key)
    elsif in_private?(message)
      if text =~ /^\/leave +([0-9]+)$/
        days = $1.to_i
        add_leave(message, days, 'leave')

        reply(message, 'Cuti berhasil didaftarkan')
      elsif text =~ /^\/remote +([0-9]+)$/
        days = $1.to_i
        add_leave(message, days, 'remote')

        reply(message, 'Remote berhasil didaftarkan')
      end
    else
      reply(message, 'wow')
    end
  end

  private

  def in_private?(message)
    message.chat.type == 'private'
  end

  def register_group(message, group_name)
    begin
      LeaverBot::Group.create!(group_id: message.chat.id, name: group_name.downcase)
      'Grup ini berhasil didaftarkan dalam sistem'
    rescue
      'Grup ini sudah terdaftar sebelumnya'
    end
  end

  def registered_group?(group_name)
    LeaverBot::Group.find_by(name: /^#{group_name}$/i)
  end

  def register_user(username, group)
    if LeaverBot::User.where(username: /^#{username}$/i, group_list: group.name).first
      "Sudah terdaftar di grup #{group.name} sebelumnya"
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

  def add_leave(message, duration, type)
    LeaverBot::Leave.add_leave(message, duration, type)
  end

  def reply(message, text)
    send(chat_id: message.chat.id, text: text, reply_to_message_id: message.message_id)
  end

  def send(options = {})
    LeaverBot::MessageSender.perform_async(@bot, options)
  end
end
