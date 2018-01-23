class LeaverBot::User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id,     type: Integer
  field :first_name,  type: String
  field :last_name,   type: String
  field :username,    type: String
  field :active,      type: Boolean, default: true
  field :group_list,  type: Array, default: []

  index({ created_at: 1 }, { background: true })
  index({ user_id: 1 },    { background: true })
  index({ username: 1 },   { background: true })
end
