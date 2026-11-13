Laboratorium Software Architecture and Quality (SAQ) Institut Teknologi PLN mengelola
aktivitas praktikum melalui aplikasi pelaporan otomatis berbasis web. Aplikasi tersebut
dibangun di atas runtime Node.js dengan kerangka kerja Express dan basis data MongoDB,
serta melayani pencatatan data asisten, dosen, mata kuliah, jadwal, laporan harian,
rekapitulasi, hingga pengiriman pengingat melalui WhatsApp. Hampir seluruh perpindahan
data pada aplikasi ini berlangsung dalam format JavaScript Object Notation (JSON):
dokumen pada MongoDB diserialisasi sebagai JSON, konfigurasi aplikasi tersimpan sebagai
berkas JSON, dan payload antara klien dengan server juga berbentuk JSON. Karakter format
ini yang ringan, berbasis teks, dan independen terhadap bahasa pemrograman
@10.17487_RFC8259 menjadikannya pilihan alami bagi aplikasi berbasis layanan, tetapi
karakter yang sama juga berarti setiap operasi data menanggung biaya pemrosesan teks.

Setiap pembacaan nilai JSON pada aplikasi tidak menemui data berstruktur, melainkan
teks yang harus diurai. Strategi yang lazim dipakai pustaka parser mengonversi seluruh
teks masukan menjadi pohon objek utuh berbasis Document Object Model (DOM) sebelum
aplikasi dapat membaca nilainya @10.48550_arXiv.1902.08318. Model eksekusi tersebut
menempatkan biaya pada saat yang salah: validasi, alokasi memori, dan pembentukan objek
dibayarkan untuk seluruh isi dokumen, termasuk bagian yang tidak akan pernah dibaca
oleh aplikasi. Pada beban kerja yang hanya memerlukan sebagian kecil isi dokumen,
strategi tanpa pohon parse terbukti menekan konsumsi memori secara drastis
@10.1145_3297858.3304008, sementara beragam upaya menangguhkan pekerjaan hingga nilai
benar-benar dibutuhkan, mulai dari indeks yang dibangun malas sampai filter yang
didorong masuk ke tahap parsing, bermuara pada kesimpulan yang sama bahwa membayar
biaya untuk seluruh dokumen sering kali tidak perlu
@10.14778_3115404.3115416 @10.14778_3236187.3236207 @10.1145_3503222.3507719.

Kebutuhan mengendalikan biaya tersebut melahirkan satu kontinum strategi parsing yang
pergeserannya dapat dibaca dari apa yang ditangguhkan dan apa yang disimpan. Pada ujung
pertama, parser DOM membayar seluruh biaya di awal lalu menyimpan pohon utuh, sehingga
akses berikutnya murah tetapi memori tumbuh sebesar dokumen. Pada ujung lainnya,
pemrosesan mengalir (streaming) memvalidasi sambil lewat lalu membuang struktur, sehingga
memori tetap kecil tetapi akses terbatas pada urutan masuk
@10.14778_3778092.3778109. Di antara keduanya, strategi on-demand menawarkan titik
tengah: antarmuka yang tampak seperti parser DOM bagi pemrogram, tetapi internalnya
hanya menggerakkan penunjuk melalui teks masukan dan mematerialisasi nilai secara
malas saat diminta @10.1002_spe.3313. Bagi aplikasi yang membaca nilai secara selektif
dan acak, bukan aliran berurutan, titik tengah ini menempatkan biaya parsing persis
pada bagian yang dibaca.

Layak atau tidaknya strategi tanpa pohon tersebut pada aplikasi nyata sangat
ditentukan oleh fondasi mekanisnya, karena kursor yang bergerak per karakter hanya
menggantikan satu biaya besar dengan biaya kecil yang berulang. Pemindaian struktural
bit-paralel menutup kelemahan itu: dengan teknik SWAR (SIMD Within A Register) dan
instruksi SIMD, posisi tanda kutip, kurung, dan pemisah dokumen direkam dalam satu
lintasan @10.48550_arXiv.1902.08318, sehingga navigasi on-demand dapat melompat langsung
ke posisi nilai alih-alih mengulang pemindaian teks. Kematangan teknik ini ditandai
oleh diadopsinya antarmuka on-demand pada sistem produksi seperti Node.js, Apache
Doris, Milvus, dan Velox @10.1002_spe.3313.

Menghadirkan implementasi parser berkinerja tinggi, yang lazim ditulis dalam C++,
ke dalam aplikasi Node.js membutuhkan jembatan eksekusi lintas bahasa. WebAssembly
(Wasm) menyediakan format biner portabel dengan lingkungan eksekusi terpasir
(sandboxed) yang dapat dipanggil langsung dari JavaScript @10.1145_3714465. Bukti
lintas lingkungan menunjukkan kinerja Wasm umumnya lebih cepat daripada JavaScript
dan mendekati kode native pada beban komputasi, termasuk di sisi server
@10.1109_CLEI53233.2021.9640153 @10.1109_IcETRAN62308.2024.10645198
@10.1145_3572848.3577436, dan ekosistem Node.js telah memuat ratusan paket produksi
yang mengintegrasikan modul Wasm @10.1145_3744916.3764533. Dengan demikian, pola
integrasi parser berbasis Wasm pada aplikasi server JavaScript tergolong mapan dan
teruji.

Di sisi lain, pertimbangan rekayasa menuntut agar keputusan adopsi tidak diambil dari
angka korpus generik semata. Penghilangan pohon menghadirkan perpindahan beban: biaya
parsing yang semula sekali dibayar kini berpindah ke prosesor setiap kali data diakses,
ditambah biaya tetap persilangan memori antar batas Wasm dan JavaScript
@10.31649_vitce_2.2026.121. Kinerja Wasm berbanding JavaScript juga terbukti sangat
bergantung pada lingkungan eksekusi @10.1145_3487552.3487827 @10.1109_ASE56229.2023.00088,
dan literatur pengukuran menegaskan bahwa perbandingan kinerja lintas lingkungan tanpa
dokumentasi kondisi eksekusi mudah menyesatkan @10.1145_2807591.2807644. Konsekuensinya,
pertanyaan kelayakan hanya dapat dijawab dengan pengukuran yang menahan seluruh
variabel selain parser tetap konstan: perangkat keras yang sama, runtime yang sama,
dan kondisi beban server yang tercatat.

Menempatkan seluruh pertimbangan di atas menghadirkan peta ruang bukti yang jelas.
Bukti kuantitatif atas strategi on-demand, pemindaian bit-paralel, dan integrasi Wasm
telah terkumpul rapat pada korpus benchmark sintetis dan beban kerja analitik skala
besar @10.48550_arXiv.1902.08318 @10.1145_3503222.3507719 @10.1002_spe.3313. Titik pada
peta itu yang belum tertutup adalah aplikasi operasional nyata: pola aksesnya parsial,
ukuran payloadnya menengah, dan layanannya berjalan terus-menerus, sehingga pertukaran
beban antara memori dan prosesornya tidak otomatis dapat disimpulkan dari pengukuran
korpus generik. Aplikasi pelaporan SAQ berada persis pada titik tersebut, dan jalur
pemrosesan JSON-nya saat ini masih membayar strategi DOM utuh melalui JSON.parse
bawaan runtime pada setiap pembacaan berkas, serta melalui pasangan serialisasi-parsing
pada penggandaan data di lapisan penyimpanan.

Penelitian ini mengambil tempat pada titik yang kosong tersebut dengan mengevaluasi
Parser JSON On-Demand ze_json pada studi kasus aplikasi pelaporan SAQ. ze_json adalah
parser JSON on-demand satu lintasan berbasis C++23 dengan pemindaian struktural SWAR
yang dikompilasi ke WebAssembly 64-bit dan diekspos ke runtime Node.js melalui
antarmuka binding JavaScript. Kinerja baseline saat ini dan hasil setelah implementasi
dibandingkan pada lingkungan perangkat keras yang identik dan tertutup, dalam satuan
nanosecond dan nanosecond per operasi (ns/op) atas pemanggilan fungsi parser, disertai
pencatatan beban prosesor harian sebelum implementasi agar dampak teknis yang teramati
dapat dikaitkan langsung dengan perubahan parser, bukan dengan variasi lingkungan.
Melalui perancangan tersebut, penelitian ini diharapkan memberikan dua kontribusi
sekaligus: bukti empiris kelayakan parser on-demand pada aplikasi pelaporan nyata,
dan metodologi evaluasi yang tertib dalam menghindari bias lingkungan.
