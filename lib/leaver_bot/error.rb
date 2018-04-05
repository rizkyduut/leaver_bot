module LeaverBot
  class Error < RuntimeError; end

  class PrivilegeError < Error
    def initialize(msg = 'Anda tidak berhak mengakses menu ini')
      super
    end
  end
end
