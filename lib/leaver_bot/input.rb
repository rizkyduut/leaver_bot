module LeaverBot
  class Input
    include SuckerPunch::Job
    workers 5

    def perform(bot, message)
      return unless message
      return if message.edit_date
      return unless message.text

      message.text = message.text.sub("@#{$bot_username}", '')
      LeaverBot::User.get_and_update(message.from)
      cmd = Command
        .actions
        .find { |command| command.matches(message.text) }
        .new(bot, message)

      begin
        cmd.perform
      rescue LeaverBot::Error => e
        cmd.reply(e.message)
      end
    end
  end
end
