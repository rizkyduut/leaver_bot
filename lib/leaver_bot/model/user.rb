module LeaverBot
  class User
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Locker

    field :user_id,     type: Integer
    field :first_name,  type: String
    field :last_name,   type: String
    field :username,    type: String
    field :active,      type: Boolean, default: true

    index({ created_at: 1 }, { background: true })
    index({ user_id: 1 },    { background: true })
    index({ username: 1 },   { background: true })

    default_scope -> { order_by(created_at: :asc) }
    scope :active, -> { where(active: true) }

    def self.get(username)
      self.active.find_by(username: username)
    end

    def self.get_and_update(tg_user)
      res = self.active.find_by(user_id: tg_user.id)
      LeaverBot::Group.update_group(res.username, tg_user.username) if res&.username?
      res ||= self.active.where(username: /^#{tg_user.username}$/i).first

      if res
        res.with_lock(wait: true) do
          res.user_id = tg_user.id
          res.first_name = tg_user.first_name
          res.last_name = tg_user.last_name
          res.username = tg_user.username
          res.save if res.changed?
        end
      end

      res
    end
  end
end
