import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../lib/models/message2.dart';

class ChatServices {


  //get instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //user stream
  Stream<List<Map<String,dynamic>>> getUserStream(){
    return _firestore.collection("Users").snapshots().map((snapshot){
      return snapshot.docs.map((doc)
      {
        // go through each individual user
        final user = doc.data();
        
        return user;
      }).toList();

    });
  }

  // Send message
Future<void> sendMessage(String receiverID, message) async {
  // get current user info
  final String currentUserID = _auth.currentUser!.uid;
  final String currentUserEmail = _auth.currentUser!.email!;
  final Timestamp timestamp = Timestamp.now();

  // create a new message 
  Message newMessage = Message(
    senderID: currentUserID, 
    senderEmail: currentUserEmail, 
    receiverID: receiverID, 
    message: message, 
    timestamp: timestamp);
 
  // Construct chat ID for two users
  List<String> ids = [currentUserID, receiverID];
  ids.sort();
  String chatRoomID = ids.join('_');

  // Save message to DB
  await _firestore
      .collection("chat_rooms")
      .doc(chatRoomID)
      .collection("messages")
      .add(newMessage.toMap());
}

  // get messages
  Stream<QuerySnapshot> getMessages(String userID, otherUserID){
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
    .collection("chat_rooms")
    .doc(chatRoomID)
    .collection("messages")
    .orderBy("timestamp", descending: false)
    .snapshots();
  }


}