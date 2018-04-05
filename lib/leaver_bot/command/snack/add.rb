module LeaverBot
  class Command
    class Snack
      class Add < Snack
        COMMAND_REGEX = /^\/add_snack/

        def self.matches(text)
          text =~ COMMAND_REGEX
        end

        def perform
          super

          if group = registered_group?(@group_name)
            register_snack(group, @usernames, @day)

            reply("#{@usernames.join(', ')} berhasil didaftarkan untuk hari #{@day}")
          else
            reply('Group tidak ditemukan')
          end
        end

        def register_snack(group, usernames, day)
          LeaverBot::Snack.add(group, usernames, day)
        end
      end
    end
  end
end
