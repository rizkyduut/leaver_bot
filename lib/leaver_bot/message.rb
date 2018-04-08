module LeaverBot
  class Message
    class << self
      def help_text
        msg = []
        msg << 'Untuk menggunakan bot ini, pertama-tama invite dulu ke group yang diinginkan lalu ketik command berikut di dalam group tersebut:'
        msg << "<code>/add_group [nama group]</code>"
        msg << "Contoh: <b>/add_group teltub</b>."
        msg << ''
        msg << 'Setelah itu, daftarkan anggota group yang diinginkan dengan:'
        msg << "<code>/add @[username (boleh lebih dari satu)] [nama group]</code>"
        msg << "Contoh: <b>/add_user @rizkyduut @tuudykzir teltub</b>."
        msg << ''
        msg << 'Untuk melihat siapa saja yang tidak hadir dapat menggunakan /status di dalam group tersebut'
        msg << ''
        msg << 'Bagaimana cara input data ketidakhadirannya? Username yang telah didaftarkan tadi bisa langsung japri ke sini dengan /cuti /sakit /remote /reset /status'
        msg << ''
        msg << 'Suka lupa input data? pake /reminder aja'
        msg.join("\n")
      end

      def leave_text(type)
        msg = []
        msg << "<code>/#{type} [jumlah hari terhitung hari ini]</code>"
        msg << "Contoh: <b>/#{type} 1</b> untuk mendaftarkan data #{type} hari ini saja"
        msg << "<b>/#{type} 6</b> untuk mendaftarkan data #{type} sebanyak 6 hari (sabtu minggu dihitung)"
        msg.join("\n")
      end

      def reset_text
        msg = []
        msg << "<code>/reset [jumlah hari terhitung hari ini]</code>"
        msg << 'Mirip sama leave/remote tapi ini menghapus <b>semua</b> data sebanyak jumlah hari ke depan'
        msg.join("\n")
      end

      def status_text
        msg = []
        msg << 'COMING SOON'
        msg.join("\n")
      end

      def reminder_text
        msg = []
        msg << '<code>/reminder [y/n]</code>'
        msg << "<b>/reminder y</b> untuk mengaktifkan fitur reminder yang akan dikirim setiap jam 6 pagi"
        msg << "<b>/reminder n</b> untuk menonaktifkan fitur reminder"
        msg.join("\n")
      end
    end
  end
end
