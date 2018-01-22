class LeaverBot::User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id,     type: Integer
  field :first_name,  type: String
  field :last_name,   type: String
  field :username,    type: String
  field :squad,       type: Integer
  field :active,      type: Boolean, default: true

  has_many :squad, class_name: 'LeaverBot::Squad', inverse_of: :user


end
