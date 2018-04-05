module LeaverBot
  class Command
    class Group
      class Add < Group
        COMMAND_REGEX = /^\/add_group/

        def self.matches(text)
          text =~ COMMAND_REGEX
        end

        def perform
          super
          return unless @message.chat.id < 0

          group_name = args
          LeaverBot::Group.create!(group_id: @message.chat.id, name: group_name)
          reply('Group ini berhasil didaftarkan dalam sistem')
        rescue
          reply('Group ini sudah terdaftar sebelumnya')
        end
      end
    end
  end
end
