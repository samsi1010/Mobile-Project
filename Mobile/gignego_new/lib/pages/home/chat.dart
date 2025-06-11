import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

class Message {
  final int id;
  final String senderEmail;
  final String receiverEmail;
  final String message;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.senderEmail,
    required this.receiverEmail,
    required this.message,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderEmail: json['sender_email'],
      receiverEmail: json['receiver_email'],
      message: json['message'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class ChatPage extends StatefulWidget {
  final String chatWithEmail;
  final int? jobId;

  const ChatPage({Key? key, required this.chatWithEmail, this.jobId}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> messages = [];
  TextEditingController _controller = TextEditingController();
  Timer? _timer;
  ScrollController _scrollController = ScrollController();

  String? currentUserEmail;
  bool _loading = true;

  @override
void initState() {
  super.initState();
  print('chatWithEmail: ${widget.chatWithEmail}');
  print('jobId: ${widget.jobId}');
  _loadCurrentUserEmail();
}


  Future<void> _loadCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');

    setState(() {
      currentUserEmail = email;
      _loading = false;
    });

    if (email != null) {
      await _loadMessages();
      _timer = Timer.periodic(Duration(seconds: 5), (timer) {
        _loadMessages();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    if (currentUserEmail == null) return;
if (widget.jobId == null) {
  print('Warning: jobId null, chat mungkin tidak bisa ditampilkan dengan benar.');
  return;
}

    final url = Uri.parse(
      'http://192.168.90.59:8081/messages?user1=$currentUserEmail&user2=${widget.chatWithEmail}&job_id=${widget.jobId}',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          List<dynamic> rawMessages = data['data'];
          List<Message> newMessages = rawMessages.map((json) => Message.fromJson(json)).toList();

          setState(() {
            messages = newMessages;
          });

          // Scroll ke bawah setelah data update
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
      }
    } catch (e) {
      print('Gagal load pesan: $e');
    }
  }

  Future<void> _sendMessage() async {
    if (currentUserEmail == null || widget.jobId == null) return;
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final url = Uri.parse('http://192.168.90.59:8081/messages');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'sender_email': currentUserEmail,
          'receiver_email': widget.chatWithEmail,
          'job_id': widget.jobId,
          'message': text,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          _controller.clear();
          await _loadMessages();
        }
      } else {
        print('Gagal kirim pesan: ${response.statusCode}');
      }
    } catch (e) {
      print('Error kirim pesan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text("Chat dengan ${widget.chatWithEmail}")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (currentUserEmail == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Chat dengan ${widget.chatWithEmail}")),
        body: Center(child: Text("Harap login terlebih dahulu.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Chat dengan ${widget.chatWithEmail}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? Center(child: Text("Belum ada pesan"))
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg.senderEmail == currentUserEmail;
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment:
                              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: isMe ? Colors.purple[200] : Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Text(msg.message),
                            ),
                            SizedBox(height: 4),
                            Text(
                              timeago.format(msg.createdAt, locale: 'id'),
                              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Ketik pesan...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.purple),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
