class LeaverBot::InputProcessor
  include SuckerPunch::Job
  workers 5

  attr_accessor :bot

  def perform(message, bot)
    @bot = bot

    return unless message

    # enables the bot only for private chats (chat id positive) and main group
    return unless message.chat.id > 0 || in_group?(message)

    # ignores edited messages
    return if message.edit_date

    # ignores other type of messages
    return unless message.text

    return if duplicate_message?(message)

    text = message.text.sub("@#{$bot_username}", '')

    if text =~ /^\/register +((?:@?[A-Za-z0-9_]{5,} *)+) +(.+)$/
      usernames = $1.split.map{ |u| u.sub('@', '') }
      squad = $2

      reply(message, register_user(message, usernames, squad))
    else
      reply(message, 'wow')
    end
  end

  private

  def in_group?(message)
    message.chat.id == $group_id
  end

  def duplicate_message?(message)
    LeaverBot::DuplicateHandler.duplicate?(message.chat.id, message.from.id, message.text)
  end

  def register_user()

  def reply(message, text)
    send(chat_id: message.chat.id, text: text, reply_to_message_id: message.message_id)
  end

  def send(options = {})
    LeaverBot::MessageSender.perform_async(@bot, options)
  end
end
