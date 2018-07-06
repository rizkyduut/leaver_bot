module LeaverBot
  class Input
    include SuckerPunch::Job
    workers 5

    def perform(bot, message)
      if message.kind_of?(Telegram::Bot::Types::CallbackQuery)
        cmd = Command
                  .actions
                  .find { |command| command.matches(message.data) }
                  .new(bot, message.message)
        cmd.perform
      elsif message.text
        return if message.edit_date
        before_action(message)
        cmd = Command
                  .actions
                  .find { |command| command.matches(message.text) }
                  .new(bot, message)
        cmd.perform
      else
        add_new_user(bot, message)
        remove_user(bot, message)
      end

=begin
    rescue LeaverBot::Error => e
      cmd.reply(e.message)
      LeaverBot.logger.error("#{message.from.username} - #{e.message}")
    rescue StandardError => e
      LeaverBot.logger.info(e.inspect)
=end
    end

    private

    def before_action(message)
      message.text = message.text.sub("@#{$bot_username}", '')
      LeaverBot::User.get_and_update(message.from)
      LeaverBot.logger.info("#{message.from.username} - #{message.text}")
    end

    def add_new_user(bot, message)
      return if message.new_chat_members.empty?

      message.new_chat_members.each do |user|
        unless user.is_bot
          if group = LeaverBot::Group.find_by(group_id: message.chat.id)
            LeaverBot::User.register_user(user.username, group)

            options = {
                text: "Hai @#{user.username}, Kamu sudah diinput ke Papan Absen ya!",
                parse_mode: 'HTML',
                chat_id: message.chat.id
            }
            LeaverBot.logger.info("Send greetings message to @#{user.username}")
            LeaverBot::MessageSender.perform_async(bot, options)
          end
        end
      end
    end

    def remove_user(bot, message)
      return if message.left_chat_member.nil?

      user = message.left_chat_member
      if group = LeaverBot::Group.find_by(group_id: message.chat.id)
        LeaverBot::User.remove_user(user.username, group)

        options = {
            text: "@#{user.username} telah dihapus dari Papan Absen",
            parse_mode: 'HTML',
            chat_id: message.chat.id
        }

        LeaverBot.logger.info("Send goodbye message to @#{user.username}")
        LeaverBot::MessageSender.perform_async(bot, options)
      end
    end
  end
end
