#let checkBox = table.cell(inset: (top: 0pt), box(width: 1.5em, height: 1.5em, fill: blue, stroke: 0.5pt))
Rencana jadwal penelitian disusun untuk jangka waktu enam bulan, terhitung November
2026 sampai April 2027, sebagaimana dirinci pada @tbl-jadwal dan divisualisasikan pada
@fig-jadwal. Target pendaftaran seminar proposal diatur pada bulan November 2026, dan
seluruh tahapan berikutnya diselaraskan dengan kalender akademik semester ganjil
2026/2027 sampai semester genap 2026/2027.
#text(size: 11pt)[
#figure(
  table(
    columns: (auto, 2.5em, 2.5em, 2.5em, 2.5em, 2.5em, 2.5em),
    rows: 1.5em,
    align: (left, center, center, center, center, center, center),
    stroke: 0.5pt,
    table.header(
      table.cell(rowspan: 2, align: center + horizon)[*Kegiatan*],
      table.cell(align: center)[#text(size: 9.5pt)[*Nov*]],
      table.cell(align: center)[#text(size: 9.5pt)[*Des*]],
      table.cell(align: center)[#text(size: 9.5pt)[*Jan*]],
      table.cell(align: center)[#text(size: 9.5pt)[*Feb*]],
      table.cell(align: center)[#text(size: 9.5pt)[*Mar*]],
      table.cell(align: center)[#text(size: 9.5pt)[*Apr*]],
      [], [], [], [], [], [],
    ),
    [Studi literatur dan penyusunan proposal], checkBox, [], [], [], [], [],
    [Studi kode sumber], [], checkBox, [], [], [], [],
    [Penyiapan korpus uji], [], checkBox, checkBox, [], [], [],
    [Pengukuran baseline], [], [], checkBox, [], [], [],
    [Implementasi integrasi ze_json], [], [], checkBox, checkBox, [], [],
    [Pengukuran perlakuan], [], [], [], checkBox, [], [],
    [Evaluasi dan analisis data], [], [], [], checkBox, checkBox, [],
    [Penyusunan laporan], [], [], [], [], checkBox, checkBox,
    [Revisi dan persiapan sidang], [], [], [], [], [], checkBox,
  ),
  caption: [Rencana jadwal penelitian enam bulan],
) <tbl-jadwal>
]

#figure(
  image("../../assets/images/jadwal-penelitian.png", width: 100%),
  caption: [Diagram Gantt rencana jadwal penelitian],
) <fig-jadwal>
