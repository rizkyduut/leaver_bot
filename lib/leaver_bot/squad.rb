class LeaverBot::Squad
  include Mongoid::Document
  include Mongoid::Timestamps

  field :group_id,    type: Integer
  field :group_name,  type: String

  belongs_to :user, class_name: 'LeaverBot::User', inverse_of: :squad
end
