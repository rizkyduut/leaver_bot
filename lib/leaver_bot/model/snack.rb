module LeaverBot
  class Snack
    include Mongoid::Document
    include Mongoid::Timestamps

    field :group_id,  type: Integer
    field :monday,    type: Array, default: []
    field :tuesday,   type: Array, default: []
    field :wednesday, type: Array, default: []
    field :thursday,  type: Array, default: []
    field :friday,    type: Array, default: []

    validates :group_id, uniqueness: true

    index({ created_at: 1 }, { background: true })
    index({ group_id: 1 }, { background: true })

    default_scope -> { order_by(created_at: :asc) }

    belongs_to :group, class_name: "LeaverBot::Group", inverse_of: :snack

    HOLIDAY_KEY = 'holiday'.freeze

    def self.add(group, usernames, day)
      snack_group = find_or_create_by(group: group)
      snack_group.group = group

      case day
      when 'senin'
        snack_group.monday = usernames
      when 'selasa'
        snack_group.tuesday = usernames
      when 'rabu'
        snack_group.wednesday = usernames
      when 'kamis'
        snack_group.thursday = usernames
      when "jum'at"
        snack_group.friday = usernames
      end

      snack_group.save! if snack_group.changed?
    end

    def self.options
      {
        text: 'Jangan lupa jajan ya hari ini ',
        parse_mode: 'HTML'
      }
    end

    def today
      case
      when Date.today.monday?
        self.monday
      when Date.today.tuesday?
        self.tuesday
      when Date.today.wednesday?
        self.wednesday
      when Date.today.thursday?
        self.thursday
      when Date.today.friday?
        self.friday
      end
    end
  end
end
