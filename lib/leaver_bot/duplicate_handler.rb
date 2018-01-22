class LeaverBot::DuplicateHandler

  def self.duplicate?(chat_id, from_id, text)
    this_key = "previous_message_#{chat_id}_#{from_id}"
    if $redis.get(this_key) == text
      return true
    end
    $redis.setex(this_key, 300, text)
    false
  end
end
