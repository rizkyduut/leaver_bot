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
        msg << "<code>/add_user @[username (boleh lebih dari satu)] [nama group]</code>"
        msg << "Contoh: <b>/add_user @rizkyduut @tuudykzir teltub</b>."
        msg << ''
        msg << 'Untuk melihat siapa saja yang tidak hadir dapat menggunakan /status di dalam group tersebut'
        msg << ''
        msg << 'Bagaimana cara input data ketidakhadirannya? Username yang telah didaftarkan tadi bisa langsung japri ke sini dengan /cuti /sakit /remote /reset /my_status'
        msg << ''
        msg << 'Suka lupa input data? pake /reminder aja'
        msg << ''
        msg << "Untuk melihat daftar perintah lengkap, gunakan perintah /help_commands."
        msg.join("\n")
      end

      def help_commands_text
        msg = []
        msg << "<b>Perintah di group chat</b>"
        msg << "======================"
        msg << "Gunakan <code>/add_group [nama grup]</code> untuk mendaftarkan grup ke papan absen."
        msg << ''
        msg << "Gunakan <code>/add_user @[username (boleh lebih dari satu)] [nama grup]</code> untuk mendaftarkan user ke dalam grup."
        msg << ''
        msg << "Gunakan /delete_group untuk menghapus grup dari Papan Absen."
        msg << ''
        msg << "Gunakan <code>/add_snack @[username (boleh lebih dari satu)] [nama grup] [hari (senin, selasa, etc.)]</code> untuk membuat pengingat piket jajan harian."
        msg << ''
        msg << "Gunakan /standup untuk mengatur pengingat stand-up meeting harian"
        msg << ""
        msg << "Gunakan /status untuk memeriksa absensi anggota grup hari ini."
        msg << ""
        msg << "<b>Perintah di private chat</b>"
        msg << "========================"
        msg << "Gunakan /cuti untuk mendaftarkan cuti kamu."
        msg << ""
        msg << "Gunakan /remote untuk mendaftarkan remote kamu."
        msg << ""
        msg << "Gunakan /sakit untuk mendaftarkan cuti sakit kamu."
        msg << ""
        msg << "Gunakan /reset untuk menghapus data cuti/sakit/remote kamu."
        msg << ""
        msg << "Gunakan /status untuk memeriksa data cuti kamu atau grup yang kamu ikuti pada bulan ini."
        msg << ""
        msg << "Gunakan /check_status untuk mengetahui status cuti seseorang yang terdaftar di Papan Absen."
        msg << ""
        msg << "Gunakan /reminder untuk mengaktifkan/menonaktifkan pengingat untuk mendaftarkan cuti setiap hari."

        msg.join("\n")
      end

      def leave_text(type)
        optional_date = " [tanggal mulai #{type} (opsional, format DD-MM-YYYY)]"
        msg = []
        msg << "<code>/#{type} [jumlah hari terhitung hari ini]#{optional_date unless type == 'sakit'}</code>"
        msg << ""
        msg << "Contoh:"
        msg << "<b>/#{type} 1</b> untuk mendaftarkan data #{type} hari ini saja"
        msg << "<b>/#{type} 3 08-05-2018</b> untuk mendaftarkan #{type} sebanyak 3 hari mulai dari tanggal 8 Mei 2018 (sabtu minggu dihitung)" unless type == 'sakit'
        msg << "<b>/#{type} 6</b> untuk mendaftarkan data #{type} sebanyak 6 hari (sabtu minggu dihitung)"
        msg.join("\n")
      end

      def reset_text
        msg = []
        msg << "<code>/reset [jumlah hari terhitung hari ini / tanggal awal] [tanggal awal (opsional, format DD-MM-YYYY)]</code>"
        msg << ""
        msg << 'Contoh:'
        msg << "<b>/reset 3</b> menghapus data absensi kamu untuk 3 hari ke depan termasuk hari ini"
        msg << "<b>/reset 3 08-05-2018</b> menghapus data absensi kamu sebanyak 3 hari mulai dari tanggal 8 Mei 2018"
        msg.join("\n")
      end

      def reminder_text
        msg = []
        msg << '<code>/reminder [y/n]</code>'
        msg << ""
        msg << "Contoh:"
        msg << "<b>/reminder y</b> untuk mengaktifkan fitur reminder yang akan dikirim setiap jam 6 pagi"
        msg << "<b>/reminder n</b> untuk menonaktifkan fitur reminder"
        msg.join("\n")
      end

      def check_status_text
        msg = []
        msg << "<code>/check_status @[username]</code>"
        msg << ""
        msg << "Contoh:"
        msg << "<b>/check_status @rizkyduut</b> memeriksa status absensi username @rizkyduut hari ini"
        msg.join("\n")
      end
    end
  end
end
