module LeaverBot
  class Group
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Locker

    field :group_id,    type: Integer
    field :name,        type: String
    field :admin,       type: Integer
    field :standup,     type: String
    field :user_list,   type: Array, default: []

    validates :group_id, uniqueness: true
    validates :name, presence: true, uniqueness: true, case_sensitive: false

    index({ created_at: 1 }, { background: true })
    index({ group_id: 1 }, { background: true })
    index({ name: 1 }, { background: true })

    default_scope -> { order_by(created_at: :asc) }

    has_one :snack, class_name: "LeaverBot::Snack", inverse_of: :group, dependent: :destroy

    def self.update_group(old_username, new_username)
      return if old_username.eql?(new_username)

      self.where(user_list: old_username).each do |group|
        group.with_lock(wait: true) do
          group.user_list.map! { |user| user == old_username ? new_username : user }
          group.save if group.changed?
        end
      end
    end

    def validate_admin(user_id)
      self.admin == user_id
    end

    def self.standup_options
      {
        text: 'AYO ANAK-ANAK STAND UP YAAA',
        parse_mode: 'HTML'
      }
    end
  end
end
