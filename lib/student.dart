class Student {
  final int? id;
  final String nama;
  final int nim;
  final String mataKuliah;
  final double nilaiUAS;
  final double nilaiUTS;

  Student({
    this.id,
    required this.nama,
    required this.nim,
    required this.mataKuliah,
    required this.nilaiUAS,
    required this.nilaiUTS,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'nim': nim,
      'mata_kuliah': mataKuliah,
      'nilai_uas': nilaiUAS,
      'nilai_uts': nilaiUTS,
    };
  }
}
