class LeaverBot::InputProcessor

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

    if text =~ /^\/kodok( verbose)?/i
      reply(message, 'kodok')
    end
  end

  private

  def duplicate_message?(message)
    HighfiveBot::DuplicateHandler.duplicate?(message.chat.id, message.from.id, message.text)
  end

  def reply(message, text)
    send(chat_id: message.chat.id, text: text, reply_to_message_id: message.message_id)
  end
end
