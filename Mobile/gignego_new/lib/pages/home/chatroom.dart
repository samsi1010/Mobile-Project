import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application/pages/home/chat.dart';

// Model ChatRoom
class ChatRoom {
  final String chatPartnerEmail;
  final DateTime lastMessageTime;
 final int jobId;

  ChatRoom({
    required this.chatPartnerEmail,
    required this.lastMessageTime,
    required this.jobId,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      chatPartnerEmail: json['chat_partner_email'],
      lastMessageTime: DateTime.parse(json['last_message_time']),
      jobId: json['job_id'],
    );
  }
}

// Widget Daftar Room Chat dengan fetch data
class ChatRoomListPage extends StatefulWidget {
  final String currentUserEmail;

  const ChatRoomListPage({Key? key, required this.currentUserEmail}) : super(key: key);

  @override
  _ChatRoomListPageState createState() => _ChatRoomListPageState();
}

class _ChatRoomListPageState extends State<ChatRoomListPage> {
  late Future<List<ChatRoom>> _chatRoomsFuture;

  @override
  void initState() {
    super.initState();
    _chatRoomsFuture = fetchChatRooms(widget.currentUserEmail);
  }

  Future<List<ChatRoom>> fetchChatRooms(String userEmail) async {
<<<<<<< Updated upstream
  final url = Uri.parse('http://192.168.130.184:8080/chatrooms?user_email=$userEmail');
=======
  final url = Uri.parse('http://192.168.34.59:8081/chatrooms?user_email=$userEmail');
>>>>>>> Stashed changes
  final response = await http.get(url);

  print('Status code: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['status'] == 'success') {
      List<dynamic> rawRooms = data['data'];
      return rawRooms.map((json) => ChatRoom.fromJson(json)).toList();
    }
    throw Exception('API response status error');
  } else {
    throw Exception('Failed to load chat rooms');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Chat')),
      body: FutureBuilder<List<ChatRoom>>(
        future: _chatRoomsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat daftar chat'));
          }
          final rooms = snapshot.data ?? [];
          if (rooms.isEmpty) {
            return Center(child: Text('Belum ada chat'));
          }
          return ListView.builder(
  itemCount: rooms.length,
  itemBuilder: (context, index) {
    final room = rooms[index];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        title: Text(room.chatPartnerEmail),
        subtitle: Text('Terakhir chat: ${room.lastMessageTime.toLocal()}'),
        onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ChatPage(
        chatWithEmail: room.chatPartnerEmail,
        jobId: room.jobId,
      ),
    ),
  );
},

      ),
    );
  },
);
        },
      ),
    );
  }
}

// // Dummy placeholder ChatPage, ganti dengan implementasi Anda
// class ChatPage extends StatelessWidget {
//   final String chatWithEmail;

//   const ChatPage1({Key? key, required this.chatWithEmail}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Chat dengan $chatWithEmail')),
//       body: Center(child: Text('Halaman chat dengan $chatWithEmail')),
//     );
//   }
// }
