module LeaverBot
  class Command
    class Status
      class Info < Status
        COMMAND_REGEX = /^\/info/

        def self.matches(text)
          text =~ COMMAND_REGEX
        end

        def perform
          super

          info = []
          info.push("Group <b>#{@group.name}</b>")
          info.push("Admin group: @#{group_admin}")
          info.push("Jadwal stand-up: #{standup_time}")
          reply(info.join("\n"))
        end

        private

        def group_admin
          LeaverBot::User.find_by(user_id: @group.admin).username
        end

        def standup_time
          @group&.standup || 'Belum diset'
        end
      end
    end
  end
end
