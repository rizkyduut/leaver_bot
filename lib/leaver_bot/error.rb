module LeaverBot
  class Error < RuntimeError; end

  class PrivilegeError < Error
    def initialize(msg = 'Kamu tidak berhak mengakses menu ini')
      super
    end
  end

  class GroupNotRegisteredError < Error
    def initialize(msg = 'Group ini belum didaftarkan ke dalam sistem')
      super
    end
  end

  class GroutpNotFoundError < Error
    def initialize(msg = 'Group tidak ditemukan')
    end
  end

  class UserNotRegisteredError < Error
    def initialize(msg = 'Kamu belum terdaftar ke dalam sistem')
      super
    end
  end

  class InGroupError < Error
    def initialize(msg = 'Japri aja ya')
      super
    end
  end

  class InPrivateError < Error
    def initialize(msg = 'Perintah ini hanya bisa digunakan di dalam group')
      super
    end
  end

  class InHolidayError < Error
    def initialize(msg = 'Liburan gih sana')
      super
    end
  end
end
