require 'leaver_bot/command/help'
require 'leaver_bot/command/help_commands'
require 'leaver_bot/command/reminder'
require 'leaver_bot/command/dump'

require 'leaver_bot/command/sudo'
require 'leaver_bot/command/sudo/cache'
require 'leaver_bot/command/sudo/cache_type'
require 'leaver_bot/command/sudo/holiday'
require 'leaver_bot/command/sudo/keys'
require 'leaver_bot/command/sudo/delete'

require 'leaver_bot/command/group'
require 'leaver_bot/command/group/add'
require 'leaver_bot/command/group/delete'

require 'leaver_bot/command/user'
require 'leaver_bot/command/user/add'

require 'leaver_bot/command/status'
require 'leaver_bot/command/status/leave'
require 'leaver_bot/command/status/snack'
require 'leaver_bot/command/my_status'
require 'leaver_bot/command/check_status'
require 'leaver_bot/command/monthly_status'

require 'leaver_bot/command/leave'
require 'leaver_bot/command/leave/cuti'
require 'leaver_bot/command/leave/sick'
require 'leaver_bot/command/leave/remote'
require 'leaver_bot/command/leave/reset'

require 'leaver_bot/command/snack'
require 'leaver_bot/command/snack/add'

require 'leaver_bot/command/meeting'
require 'leaver_bot/command/meeting/standup'

module LeaverBot
  class Command
    attr_accessor :bot, :message

    def self.actions
      [
        Sudo::Keys, Sudo::Cache, Sudo::CacheType, Sudo::Holiday, Sudo::Delete,
        Group::Add, Group::Delete,
        User::Add,
        Status::Leave, Status::Snack,
        Leave::Cuti, Leave::Sick, Leave::Remote, Leave::Reset,
        Meeting::Standup,
        Snack::Add,
        Help, HelpCommands, Reminder,
        MyStatus, CheckStatus, MonthlyStatus,
        Dump,
      ]
    end

    def initialize(bot, message)
      @bot = bot
      @message = message
    end

    def in_private?
      @message.chat.type == 'private'
    end

    def registered_user?
      LeaverBot::User.get(@message.from.username)
    end

    def registered_group?(group_name)
      LeaverBot::Group.find_by(name: /^#{group_name}$/i)
    end

    def raw_text
      @message.text
    end

    def stripped_text
      raw_text.gsub(self.class::COMMAND_REGEX, '')
    end

    def display_date(date)
      I18n.l(date, format: :default)
    end

    def send_message(text)
      send(options(text))
    end

    def reply(text)
      send(options_with_reply(text))
    end

    private

    def options(text)
      {
        chat_id: @message.chat.id,
        text: text,
      }
    end

    def options_with_reply(text)
      options(text).merge(reply_to_message_id: @message.message_id)
    end

    def send(options)
      LeaverBot::MessageSender.perform_async(@bot, options)
    end
  end
end
