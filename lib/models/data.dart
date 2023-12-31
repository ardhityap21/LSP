class Transaksi {
  int? id; 
  String tanggal;
  String keterangan;
  String jenis; 
  double jumlah;

  Transaksi({
    this.id,
    required this.tanggal,
    required this.keterangan,
    required this.jenis,
    required this.jumlah,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id, 
      'tanggal': tanggal,
      'keterangan': keterangan,
      'jenis': jenis,
      'jumlah': jumlah,
    };
  }

  factory Transaksi.fromMap(Map<String, dynamic> map) {
    return Transaksi(
      id: map['id'],
      tanggal: map['tanggal'],
      keterangan: map['keterangan'],
      jenis: map['jenis'],
      jumlah: map['jumlah'],
    );
  }
}
