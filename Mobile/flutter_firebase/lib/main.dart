// import 'package:flutter/material.dart';
// import 'package:flutter_firebase/Services/auth/auth_gate.dart';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_firebase/Services/firebase_options.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
      
//       debugShowCheckedModeBanner: false,
//       home: AuthGate(),
//     );
//   }
// }


// import 'package:flutter/material.dart';

// import 'package:flutter_firebase/pages/profil/profil.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Profil App',
//       theme: ThemeData(
//         primarySwatch: Colors.purple,
//       ),
//       home: ProfilPage(), 
//     ); 
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_firebase/pages/activity/tampilan.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aktivitas App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: AktivitasPekerjaanPage(), 
    );
  }
}
