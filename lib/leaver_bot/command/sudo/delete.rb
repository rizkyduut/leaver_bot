module LeaverBot
  class Command
    class Sudo
      class Delete < Sudo
        COMMAND_REGEX = /^\/delete/

        def self.matches(text)
          text =~ COMMAND_REGEX
        end

        def perform
          super

          LeaverBot::Leave.delete(args)
          reply('Berhasil menghapus cache')
        end
      end
    end
  end
end
