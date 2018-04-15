module LeaverBot
  class Command
    class Group < Command
      def group_name
        @group_name ||= stripped_text.strip
      end

      def perform
        raise LeaverBot::InPrivateError if in_private?
      end
    end
  end
end
