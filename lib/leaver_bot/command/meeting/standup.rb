module LeaverBot
  class Command
    class Meeting
      class Standup < Meeting
        COMMAND_REGEX = /^\/set_standup/

        def self.matches(text)
          text =~ COMMAND_REGEX
        end

        def perform
          super

          group.update(:standup => time)

          reply("Waktu stand up #{group.name} telah diset menjadi #{time}")
        end
      end
    end
  end
end
