import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Encrypt App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _decryptedUserController =
      TextEditingController();
  final TextEditingController _decryptedPasswordController =
      TextEditingController();
  String encryptedUser = '';
  String encryptedPassword = '';
  String decryptedUser = '';
  String decryptedPassword = '';
  bool isCrypted = false;

  void _encryptData() {
    final key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1');
    final iv = encrypt.IV.fromUtf8('thisisiv12345678');
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encryptedUserResult = encrypter.encrypt(_userController.text, iv: iv);
    final encryptedPasswordResult =
        encrypter.encrypt(_passwordController.text, iv: iv);

    setState(() {
      encryptedUser = encryptedUserResult.base64;
      encryptedPassword = encryptedPasswordResult.base64;
      isCrypted = true;
    });
  }

  void _decryptData() {
    try {
      final key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1');
      final iv = encrypt.IV.fromUtf8('thisisiv12345678');
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      final decryptedUserResult = encrypter.decrypt64(encryptedUser, iv: iv);
      final decryptedPasswordResult =
          encrypter.decrypt64(encryptedPassword, iv: iv);

      setState(() {
        decryptedUser = decryptedUserResult;
        decryptedPassword = decryptedPasswordResult;
        _decryptedUserController.text = decryptedUser;
        _decryptedPasswordController.text = decryptedPassword;
      });
    } catch (error) {
      print('Error al descifrar: $error');
    }
  }

  void _clearData() {
    setState(() {
      _userController.clear();
      _passwordController.clear();
      _decryptedUserController.clear();
      _decryptedPasswordController.clear();
      encryptedUser = '';
      encryptedPassword = '';
      decryptedUser = '';
      decryptedPassword = '';
      isCrypted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encrypt App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _userController,
              decoration: const InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: isCrypted ? null : _encryptData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Cifrar datos',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Visibility(
              visible: encryptedUser.isNotEmpty || encryptedPassword.isNotEmpty,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Usuario cifrado: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        encryptedUser.isNotEmpty
                            ? encryptedUser
                            : 'No hay datos cifrados',
                      ),
                      const Text(
                        'Contraseña cifrada: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        encryptedPassword.isNotEmpty
                            ? encryptedPassword
                            : 'No hay datos cifrados',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: isCrypted ? _decryptData : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text(
                'Descifrar datos',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Visibility(
              visible: decryptedUser.isNotEmpty || decryptedPassword.isNotEmpty,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Usuario descifrado: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        decryptedUser.isNotEmpty
                            ? decryptedUser
                            : 'No hay datos descifrados',
                      ),
                      const Text(
                        'Contraseña descifrada: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        decryptedPassword.isNotEmpty
                            ? decryptedPassword
                            : 'No hay datos descifrados',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _clearData,
              child: const Text('Limpiar formulario'),
            ),
          ],
        ),
      ),
    );
  }
}
