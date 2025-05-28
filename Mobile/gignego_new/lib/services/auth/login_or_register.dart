import 'package:flutter/material.dart';
import '../../pages/chat/pages/register_page.dart';
import '../../pages/profil/login_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _loginOrRegisterState();
}

class _loginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;

  void toglePages(){
    setState(() {
      showLoginPage =!showLoginPage;
    });
  }


  @override
  Widget build(BuildContext context) {
    if(showLoginPage) {
      return LoginPage(
        onTap: toglePages,
      );
      
    } else {
      return RegisterPage(
        onTap: toglePages,
      );
    
    }
  }
}
