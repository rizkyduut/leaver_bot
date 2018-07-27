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
          info.push("<b>#{@group.name}</b>")
          info.push("Admin grup: @#{group_admin}")
          info.push("Jadwal stand up: #{@group.standup}")
          reply(info.join("\n"))
        end

        private

        def group_admin
          LeaverBot::User.find_by(user_id: @group.admin).username
        end
      end
    end
  end
end
