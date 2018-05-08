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
              replies[username] = register_user(username, group)
            end

            reply(replies.map { |username, rep| "@#{username}: #{rep}" }.join("\n"))
          else
            reply('Group tidak ditemukan')
          end
        end

        def register_user(username, group)
          if group.user_list.include?(username)
            "Sudah terdaftar di group #{group.name} sebelumnya"
          elsif user = LeaverBot::User.where(username: /^#{username}$/i).first
            group.add_to_set(user_list: username)
            'Berhasil didaftarkan ke dalam group'
          else
            new_user = LeaverBot::User.create!(username: username)
            group.add_to_set(user_list: username)
            'Berhasil didaftarkan ke Papan Absen'
          end
        end
      end
    end
  end
end
