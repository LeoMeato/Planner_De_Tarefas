import 'package:flutter/material.dart';
import 'home.dart';
import 'cadastro.dart';
import 'helper.dart';

String username = '';

class Login extends StatefulWidget {
  const Login({super.key});

  static const routeName = "/login";

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  Helper helper = Helper();

  bool loginAccepted = true;

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Center(
                child: Text('Login',
                    style: TextStyle(fontSize: 36, color: Colors.black))),
            Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.12,
                  left: 40,
                  right: 40),
              child: Column(
                children: [
                  TextField(
                    controller: userController,
                    decoration: InputDecoration(
                        labelText: 'Usuário',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        errorText: loginAccepted
                            ? null
                            : 'Usuário ou senha incorretos',
                        labelText: 'Senha',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 80,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue[50]),
                        onPressed: () async {
                          if (await helper.usuarioAtivo(
                              userController.text, passwordController.text)) {
                            int id = await helper.getID(
                                userController.text, passwordController.text);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => Home(userId: id))));
                            userController.text = "";
                            passwordController.text = "";
                          } else {
                            setState(() {
                              loginAccepted = false;
                            });
                          }
                        },
                        child: const Text(
                          'Entrar',
                          style: TextStyle(fontSize: 19, color: Colors.black),
                        )),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 80,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlue[50]),
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Cadastro(user: userController.text)));
                        },
                        child: const Text(
                          'Quero me Cadastrar',
                          style: TextStyle(fontSize: 19, color: Colors.black),
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
