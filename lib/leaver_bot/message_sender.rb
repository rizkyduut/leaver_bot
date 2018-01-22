class LeaverBot::MessageSender
  include SuckerPunch::Job
  workers 5

  DEFAULT_MESSAGE_OPTIONS = {
    parse_mode: 'HTML'
  }.freeze

  def perform(bot, options)
    options.reverse_merge!(DEFAULT_MESSAGE_OPTIONS)
    return unless options[:chat_id] && options[:text]

    options[:text].scan(/.{1,4000}/m) do |text|
      text = text.gsub(/^(?!<)\/?b?>/, '').gsub(/<\/?b?(?!>)$/, '')
      if text.scan(/<b>/).count != text.scan(/<\/b>/).count
        text = text.gsub(/<\/?b>/, '')
      end

      options[:text] = text
      bot.api.send_message(options)
      sleep(0.1)
    end
  end
end
