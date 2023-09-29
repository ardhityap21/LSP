import 'package:flutter/material.dart';
import 'package:flutter_sertifikasi_ardhit/halaman/inputdata.dart';
import 'package:flutter_sertifikasi_ardhit/halaman/setting.dart';
import 'package:intl/intl.dart';
import '../DBHelper/DBHelper.dart';
import '../models/data.dart';
import 'detailCashFlow.dart';

class HomePage extends StatefulWidget {
  final List<Transaksi> transaksiList;

  HomePage({Key? key, required this.transaksiList}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DBHelper dbHelper = DBHelper();

  double totalPengeluaran = 0.0;
  double totalPemasukkan = 0.0;
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
        totalPengeluaran = calculateTotalPengeluaran();
        totalPemasukkan = calculateTotalPemasukkan();
      });
    });
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.transaksiList != oldWidget.transaksiList) {
      totalPengeluaran = calculateTotalPengeluaran();
      totalPemasukkan = calculateTotalPemasukkan();
    }
  }

  double calculateTotalPengeluaran() {
    double total = 0.0;
    for (var transaksi in widget.transaksiList) {
      if (transaksi.jenis == "Pengeluaran") {
        total += transaksi.jumlah;
      }
    }
    return total;
  }

  double calculateTotalPemasukkan() {
    double total = 0.0;
    for (var transaksi in widget.transaksiList) {
      if (transaksi.jenis == "Pemasukan") {
        total += transaksi.jumlah;
      }
    }
    return total;
  }

  String formatCurrency(double amount) {
    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 2);
    return currencyFormat.format(amount);
  }

  Future<void> _navigateToDetailCashFlow() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailCashFlow(
          transaksiList: transaksiList,
          transaksi: transaksiList.last,
        ),
      ),
    );

    if (result != null) {
      if (result == "update") {
        setState(() {
          transaksiList = fetchTransaksiList() as List<Transaksi>;
          totalPengeluaran = calculateTotalPengeluaran();
          totalPemasukkan = calculateTotalPemasukkan();
        });
      } else if (result is Transaksi) {
        setState(() {
          transaksiList.add(result);
          totalPengeluaran = calculateTotalPengeluaran();
          totalPemasukkan = calculateTotalPemasukkan();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Home'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Rangkuman Bulan Ini',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text(
                                'Pengeluaran',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            ' ${formatCurrency(totalPengeluaran)}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Pemasukan',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          ' ${formatCurrency(totalPemasukkan)}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black, // Warna border
                                width: 2.0, // Lebar border
                              ),
                              borderRadius:
                                  BorderRadius.circular(8.0), // Radius border
                            ),
                            child: SizedBox(
                              width: 150.0,
                              height: 150.0,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Input(),
                                    ),
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 64,
                                      height: 64,
                                      child: Image.asset(
                                        'assets/images/pemasukan.png',
                                        width: 64,
                                        height: 64,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    const Text(
                                      'Tambah Pemasukkan',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black, // Warna border
                                width: 2.0, // Lebar border
                              ),
                              borderRadius:
                                  BorderRadius.circular(8.0), // Radius border
                            ),
                            child: SizedBox(
                              width: 150.0,
                              height: 150.0,
                              child: TextButton(
                                onPressed: () {
                                  if (transaksiList.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailCashFlow(
                                          transaksiList: transaksiList,
                                          transaksi: transaksiList.last,
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text('Belum ada transaksi'),
                                    ));
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 64,
                                      height: 64,
                                      child: Image.asset(
                                        'assets/images/detail.png',
                                        width: 64,
                                        height: 64,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    const Text(
                                      'Detail Cash Flow',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black, // Warna border
                                  width: 2.0, // Lebar border
                                ),
                                borderRadius:
                                    BorderRadius.circular(8.0), // Radius border
                              ),
                              child: SizedBox(
                                width: 150.0,
                                height: 150.0,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Input(),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 64,
                                        height: 64,
                                        child: Image.asset(
                                          'assets/images/pengeluaran.png',
                                          width: 64,
                                          height: 64,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      const Text(
                                        'Tambah Pengeluaran',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black, // Warna border
                                  width: 2.0, // Lebar border
                                ),
                                borderRadius:
                                    BorderRadius.circular(8.0), // Radius border
                              ),
                              child: SizedBox(
                                width: 150.0,
                                height: 150.0,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Setting(),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 64,
                                        height: 64,
                                        child: Image.asset(
                                          'assets/images/setting.png',
                                          width: 64,
                                          height: 64,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      const Text(
                                        'Settings',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
