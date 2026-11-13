Penelitian dilaksanakan pada Program Studi S1 Teknik Informatika, Fakultas Telematika
Energi, Institut Teknologi PLN, yang beralamat di Jl. Duri Cengkareng Raya No.3,
Cengkareng, Jakarta Barat. Objek studi kasus adalah aplikasi pelaporan otomatis
Laboratorium Software Architecture and Quality (SAQ) yang berjalan pada server
laboratorium, dan seluruh perangkat pengembangan berupa repositori kode sumber
aplikasi SAQ serta pustaka Parser JSON On-Demand ze_json.

Penelitian direncanakan berlangsung selama enam bulan, terhitung sejak November 2026
sampai dengan April 2027. Tahap awal mencakup studi literatur dan penyusunan proposal
pada bulan November 2026, disusul studi kode sumber kedua perangkat lunak pada bulan
Desember 2026. Tahap instrumentasi berlangsung pada bulan Desember 2026 sampai
Januari 2027, mencakup penyiapan korpus uji dan pengukuran baseline. Tahap
implementasi integrasi ze_json beserta pengukuran perlakuan dilakukan pada bulan
Januari sampai Februari 2027, disusul tahap evaluasi dan analisis data pada bulan
Februari sampai Maret 2027. Tahap akhir berupa penyusunan laporan, revisi, dan
persiapan sidang dilaksanakan pada bulan Maret sampai April 2027. Rincian kegiatan
per bulan disajikan pada subbab Jadwal Penelitian.

Instrumen utama penelitian ini adalah perangkat keras dan perangkat lunak yang
menjadi lingkungan pengukuran. Sesuai prinsip lingkungan tertutup (close
environment), baseline dan perlakuan diukur pada perangkat keras yang persis sama,
yaitu server SAQ tempat aplikasi berjalan. Spesifikasi perangkat keras dan perangkat
lunak lingkungan pengukuran disajikan pada @tbl-hw dan @tbl-sw; nilai spesifikasi
tersebut akan dilengkapi dengan pembacaan langsung dari sistem pada saat pengukuran
dan tercatat pula secara otomatis pada metadata setiap run benchmark.

#figure(
  table(
    columns: (auto, auto),
    align: (left, left),
    table.header([*Komponen*], [*Spesifikasi*]),
    [Prosesor (server SAQ)], [Intel Core i5-9400, 6 inti fisik / 6 utas logis, basis 2,90 GHz],
    [Memori utama (RAM)], [8 GB, DDR4 (2 × 4 GB; berjalan pada 2133 MHz)],
    [Penyimpanan], [SSD NVMe 128 GB (V-GEN) dan HDD 2 TB (Seagate ST2000DM008)],
    [Kartu antarmuka jaringan], [Intel Ethernet Connection I219-V (tertaut 100 Mbps) dan Intel Dual Band Wireless-AC 3165; akses penguji melalui Tailscale],
    [Perangkat pengukur pendamping], [Laptop ASUS ZenBook UX425UAZ, AMD Ryzen 5 5500U (6 inti / 12 utas), RAM 8 GB; hanya untuk penyiapan, bukan kutipan lintas perangkat],
  ),
  caption: [Spesifikasi perangkat keras lingkungan pengukuran],
) <tbl-hw>

#figure(
  table(
    columns: (auto, auto),
    align: (left, left),
    table.header([*Komponen*], [*Versi dan ketentuan*]),
    [Sistem operasi], [Microsoft Windows 11 Education, build 26300 (64-bit)],
    [Runtime Node.js], [v26.13.1 (V8 14.6.202.34-node.40), wajib identik antara dev device dan server SAQ],
    [Basis data], [MongoDB 8.2.7],
    [Kompilator C++], [LLVM/clang 23.1.5 dengan C++23],
    [Sistem build], [CMake 4.4.5 dengan generator Ninja 1.13.2, dependensi via vcpkg (baseline 2026.10.16)],
    [Kerangka benchmark], [Google Benchmark 1.9.5 (native), benchmark runner Node.js (harness.mjs, nd6_bench.mjs)],
    [Kerangka uji], [GoogleTest 1.18.0],
  ),
  caption: [Spesifikasi perangkat lunak lingkungan pengukuran],
) <tbl-sw>

Sebagai bagian dari instrumentasi, beban prosesor harian server SAQ dicatat sejak
sebelum implementasi ze_json dimulai. Pencatatan dilakukan melalui sampling
pemanfaatan prosesor dan beban rata-rata (load average) pada interval tetap setiap
hari selama periode observasi, disertai identitas waktu pengambilan. Data beban
prosesor harian ini berfungsi sebagai garis dasar perilaku server sehari-hari, sehingga
perubahan beban prosesor pasca-implementasi dapat dibedakan secara jelas antara
dampak parser dan variasi operasional yang alami.
