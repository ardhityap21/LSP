import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../DBHelper/dbhelper.dart';
import '../models/data.dart';
import 'home.dart';

// ignore: must_be_immutable
class DetailCashFlow extends StatefulWidget {
  final DBHelper dbHelper = DBHelper();

  final Transaksi transaksi;
  final List<Transaksi> transaksiList;

  DetailCashFlow({
    Key? key,
    required this.transaksiList,
    required this.transaksi,
  }) : super(key: key) {
    allTransaksi =
        transaksiList.isNotEmpty ? [...transaksiList] : <Transaksi>[];

    final isDuplicate = transaksiList.any((t) => t.id == transaksi.id);

    if (!isDuplicate) {
      allTransaksi.add(transaksi);
    }
  }

  late List<Transaksi> allTransaksi;

  @override
  _DetailCashFlowState createState() => _DetailCashFlowState();
}

class _DetailCashFlowState extends State<DetailCashFlow> {
  final DBHelper dbHelper = DBHelper();
  List<Transaksi> transaksiList = [];

  Future<List<Transaksi>> fetchTransaksiList() async {
    return await dbHelper.getTransaksiList();
  }

  @override
  void initState() {
    super.initState();
    fetchTransaksiList().then((list) {
      setState(() {
        transaksiList = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Cash Flow"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(transaksiList: transaksiList),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daftar Data',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                children: widget.allTransaksi.asMap().entries.map((entry) {
                  final index = entry.key;
                  final transaksi = entry.value;
                  return Column(
                    children: [
                      if (index != 0) // Add a divider if not the first item
                        Divider(
                          thickness: 2,
                          color: Colors.grey,
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                transaksi.jenis == "Pemasukan"
                                    ? FontAwesomeIcons.arrowUp
                                    : FontAwesomeIcons.arrowDown,
                                size: 48.0, // Larger icon
                                color: transaksi.jenis == "Pemasukan"
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    transaksi.jenis == "Pemasukan"
                                        ? "Pemasukan"
                                        : "Pengeluaran",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    transaksi.keterangan,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    transaksi.tanggal,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            "Jumlah: Rp ${transaksi.jumlah.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
