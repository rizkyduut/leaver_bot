class LeaverBot::Group
  include Mongoid::Document
  include Mongoid::Timestamps

  field :group_id,    type: Integer
  field :name,  type: String
  field :user_list,   type: Array, default: []

  validates :name, uniqueness: true, case_sensitive: false

  index({ created_at: 1 }, { background: true })
  index({ group_id: 1 },    { background: true })
  index({ name: 1 },   { background: true })
end
