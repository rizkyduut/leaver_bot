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

          LeaverBot::Group.create!(group_id: @message.chat.id, name: group_name, admin: @message.from.id)
          reply('Group ini berhasil didaftarkan dalam sistem')
        rescue Mongoid::Errors::Validations
          reply('Group ini sudah terdaftar sebelumnya')
        end
      end
    end
  end
end
