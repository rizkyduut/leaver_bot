module LeaverBot
  class Command
    class Group
      class Delete < Group
        COMMAND_REGEX = /^\/delete_group/

        def self.matches(text)
          text =~ COMMAND_REGEX
        end

        def perform
          super

          group = LeaverBot::Group.find_by(group_id: @message.chat.id)
          raise LeaverBot::PrivilegeError unless group.validate_admin(@message.from.id)

          group.destroy

          reply("Group #{group.name} berhasil dihapus dari Papan Absen")
        rescue NoMethodError
          raise LeaverBot::GroupNotRegisteredError
        end
      end
    end
  end
end
