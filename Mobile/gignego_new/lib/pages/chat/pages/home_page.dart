import 'package:flutter/material.dart';
import 'chat_page.dart';
import '../../../services/auth/auth_service.dart';
import '../../../pages/API/chat_services.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ChatServices _chatServices = ChatServices();
  final AuthService _authService = AuthService();

  void logout() {
    final _auth = AuthService();
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(onPressed: logout, icon: const Icon(Icons.logout))
        ],
      ),
      drawer: Drawer(),
      body: Container(
        color: Colors.grey[200], 
        child: _buildUserList(),
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatServices.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: const Text("Error occurred", style: TextStyle(color: Colors.red)));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: 4,
        child: ListTile(
          leading: Icon(Icons.person, color: Colors.blue),
          title: Text(
            userData["email"],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  receiverEmail: userData["email"],
                  receiverID: userData["uid"],
                ),
              ),
            );
          },
        ),
      );
    } else {
      return Container();
    }
  }
}
