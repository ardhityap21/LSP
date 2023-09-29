import 'package:flutter/material.dart';
import '../DBHelper/DBHelper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/data.dart';
import 'home.dart';

class Input extends StatefulWidget {
  const Input({Key? key}) : super(key: key);

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  final DBHelper dbHelper = DBHelper();
  final TextEditingController nominalController = TextEditingController();
  final TextEditingController keteranganController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String jenis = "Pemasukan";

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _saveTransaksi() async {
    final double nominal = double.tryParse(nominalController.text) ?? 0.0;
    final String keterangan = keteranganController.text;

    if (nominal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Nominal harus Diisi"),
      ));
      return;
    }

    final Transaksi transaksi = Transaksi(
      tanggal: selectedDate.toLocal().toString().split(' ')[0],
      keterangan: keterangan,
      jenis: jenis,
      jumlah: nominal,
    );

    final Map<String, dynamic> transaksiMap = transaksi.toMap();

    try {
      await dbHelper.addTransaksi(transaksiMap);

      setState(() {
        transaksiList.add(transaksi);
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Data  berhasil disimpan"),
      ));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(transaksiList: transaksiList),
        ),
      );

      nominalController.clear();
      keteranganController.clear();
    } catch (error) {
      print("Gagal menyimpan transaksi: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal menyimpan Data: $error"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Data"),
      ),
      body: Container(
        decoration: BoxDecoration(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tambah Data",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          height: 50.0,
                          child: InkWell(
                            onTap: () => _selectDate(context),
                            child: Stack(
                              alignment: AlignmentDirectional.centerStart,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${selectedDate.toLocal()}"
                                            .split(' ')[0],
                                        style: const TextStyle(fontSize: 16.0),
                                      ),
                                      const Icon(
                                        FontAwesomeIcons.calendarAlt,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: nominalController,
                        decoration: const InputDecoration(
                          labelText: 'Nominal',
                          prefixText: 'Rp ',
                          prefixStyle: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextField(
                        controller: keteranganController,
                        decoration: const InputDecoration(
                          labelText: 'Keterangan',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: DropdownButton<String>(
                    value: jenis,
                    items: <String>['Pemasukan', 'Pengeluaran']
                        .map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              color: Colors.black, // Adjust text color
                            ),
                          ),
                        );
                      },
                    ).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        jenis = newValue!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 48.0,
                      child: ElevatedButton(
                        onPressed: () async {
                          await _saveTransaksi();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 248, 163, 35)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          elevation: MaterialStateProperty.all(5), // Add shadow
                        ),
                        child: const Text(
                          'Simpan',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      height: 48.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          nominalController.clear();
                          keteranganController.clear();
                          setState(() {
                            selectedDate = DateTime.now();
                            jenis = "Pemasukan";
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green[400]),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          elevation: MaterialStateProperty.all(5), // Add shadow
                        ),
                        child: const Text(
                          'Reset',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      height: 48.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue[600]),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          elevation: MaterialStateProperty.all(5), // Add shadow
                        ),
                        child: const Text(
                          'Kembali',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
