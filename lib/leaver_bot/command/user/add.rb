module LeaverBot
  class Command
    class User
      class Add < User
        COMMAND_REGEX = /^\/add_user/

        def self.matches(text)
          text =~ COMMAND_REGEX
        end

        def perform
          super

          if group = registered_group?(@group_name)
            replies = {}
            @usernames.each do |username|
              replies[username] = LeaverBot::User.register_user(username, group)
            end

            reply(replies.map { |username, rep| "@#{username}: #{rep}" }.join("\n"))
          else
            reply('Group tidak ditemukan')
          end
        end
      end
    end
  end
end
