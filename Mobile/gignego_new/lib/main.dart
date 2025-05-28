// import 'package:flutter/material.dart';
// import 'package:flutter_application/pages/profil/profil.dart'; 

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


// import 'package:flutter/material.dart';
// import 'package:flutter_application/pages/job//process_jobs_page.dart';
// import 'package:flutter_application/pages/job/job_list_page.dart';
// import 'package:flutter_application/pages/job/available_jobs_page.dart'; //harusnya ini login dluan sih nanti samsi aja

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Daftar Pekerjaan',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         fontFamily: 'Roboto',
//         primarySwatch: Colors.purple,
//         scaffoldBackgroundColor: const Color(0xFFF5F3FF),
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           centerTitle: true,
//           iconTheme: IconThemeData(color: Colors.black),
//           titleTextStyle: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//       ),
//       initialRoute: '/',
//       routes: {
//         '/': (context) => const JobListPage(),
//         '/available': (context) => const AvailableJobsPage(),
//         '/process' : (context) => const ProcessJobsPage(), //harusnya ini login dluan sih nanti samsi aja
//         // tambahkan lebih banyak route di sini jika kamu punya halaman lain
//       },
//     );
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:flutter_application/pages/profil/login.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Application',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: LoginPage(),
//     ); 
//   } 
// }


import 'package:flutter/material.dart';
import 'pages/auth/register_page.dart'; 
import 'pages/auth/login.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GigNego',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}