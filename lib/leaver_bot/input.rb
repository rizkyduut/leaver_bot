module LeaverBot
  class Input
    include SuckerPunch::Job
    workers 5

    def perform(bot, message)
      return unless message
      return if message.edit_date
      return unless message.text

      before_action(message)
      cmd = Command
        .actions
        .find { |command| command.matches(message.text) }
        .new(bot, message)

      begin
        cmd.perform
      rescue LeaverBot::Error => e
        cmd.reply(e.message)
        LeaverBot.logger.error("#{message.from.username} - #{e.message}")
      rescue StandardError => e
        LeaverBot.logger.info(e.inspect)
      end
    end

    private

    def before_action(message)
      I18n.locale = :id

      message.text = message.text.sub("@#{$bot_username}", '')
      LeaverBot::User.get_and_update(message.from)
      LeaverBot.logger.info("#{message.from.username} - #{message.text}" )
    end
  end
end
