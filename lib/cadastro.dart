import 'package:flutter/material.dart';
import 'home.dart';
import 'helper.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({required this.user, super.key});
  final String user;

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final emailController = TextEditingController();
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  Helper helper = Helper();

  @override
  void dispose() {
    emailController.dispose();
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
                child: Text('Seja Bem-Vindo!',
                    style: TextStyle(fontSize: 36, color: Colors.black))),
            Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.12,
                  left: 40,
                  right: 40),
              child: Column(
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        labelText: 'E-mail',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(height: 30),
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
                        labelText: 'Senha',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 80,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue[50]),
                      onPressed: () async {
                        await helper.saveUser(userController.text, emailController.text, passwordController.text);
                        int id = await helper.getID(userController.text, passwordController.text);
                        Navigator.maybePop(context).then((value) {
                          if (value){
                            Navigator.push(context, MaterialPageRoute(builder:(context) => Home(userId: id),));
                          }
                        });
                      },
                    child: const Text(
                      'Cadastre-se',
                      style: TextStyle(fontSize: 19, color: Colors.black,),
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
