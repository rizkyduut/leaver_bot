module LeaverBot
  class Command
    class Group < Command
      def args
        stripped_text.strip
      end

      def perform
        reply('Perintah ini hanya bisa digunakan di dalam group') if in_private?
      end
    end
  end
end
