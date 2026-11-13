Hipotesis penelitian dibangun dari penalaran mekanisme kerja kedua strategi parsing.
Pada jalur baseline, setiap pembacaan membayar validasi, alokasi, dan pembentukan
pohon untuk seluruh dokumen; pada jalur on-demand, biaya tersebut hanya dibayar sebesar
bagian dokumen yang benar-benar dibaca, dengan tambahan tetap berupa navigasi kursor
dan persilangan batas WebAssembly @10.1002_spe.3313
@10.31649_vitce_2.2026.121. Pola akses aplikasi pelaporan SAQ yang parsial membuat
proporsi bagian yang dibaca terhadap isi dokumen relatif kecil, sehingga secara konsep
total biaya jalur on-demand ditumbuhkan lebih rendah daripada jalur pohon utuh.
Selisih yang timbul serta konsistensinya pada payload nyata aplikasi tidak dapat
ditentukan secara teoretis, sehingga dinyatakan sebagai hipotesis yang diuji secara
empiris:
#block(inset: (left: 2em))[
	*H#sub[0]* : Tidak terdapat perbedaan yang signifikan antara baseline JSON.parse bawaan runtime dan Parser JSON On-Demand ze_json terhadap latensi pemanggilan parser, throughput, dan konsumsi memori pada aplikasi pelaporan SAQ.

	*H#sub[1]* : Penerapan Parser JSON On-Demand ze_json pada aplikasi pelaporan SAQ menurunkan latensi pemanggilan parser (nanosecond dan ns/op) serta konsumsi memori secara signifikan dibandingkan baseline, dengan kenaikan beban prosesor yang terkendali, pada lingkungan pengujian tertutup dengan perangkat keras yang identik.
]
Kedua hipotesis diuji melalui eksperimen terkendali yang dirancang pada Bab III,
dengan tingkat signifikansi 5%.
