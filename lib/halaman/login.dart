import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../DBHelper/dbhelper.dart';
import '../providers/user_provider.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserProvider _userProvider = UserProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/login.png'),
              const SizedBox(height: 20.0),
              Text(
                "PetPals Social",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  final username = _usernameController.text;
                  final password = _passwordController.text;
                  final dbHelper = DBHelper();

                  await _userProvider.fetchUserByUsername(username);
                  if (_userProvider.user != null &&
                      _userProvider.user!.password == password) {
                    final userProvider =
                        Provider.of<UserProvider>(context, listen: false);
                    userProvider.fetchUserByUsername(username);
                    final transaksiList = await dbHelper.getTransaksiList();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Login berhasil'),
                    ));

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            HomePage(transaksiList: transaksiList),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Username atau password salah'),
                    ));
                  }
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    const Size(double.infinity, 40.0),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                      Colors.blue), // Change button color to blue
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
