module LeaverBot
  class Command
    class Snack < Command
      attr_accessor :usernames, :group_name, :day

      def perform
        usernames, @group_name, @day = /((?:@[A-Za-z0-9_]{5,} *)+) (.+) (.+)/.match(stripped_text).captures
        @usernames = usernames.split.map{ |u| u.sub('@', '') }
      end
    end
  end
end
