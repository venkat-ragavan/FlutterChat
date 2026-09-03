import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget{
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final endteredMessage = _messageController.text;

    if (endteredMessage.trim().isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();
    _messageController.clear(); 

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .get();

    FirebaseFirestore.instance
      .collection('chat')
      .add({
        'text': endteredMessage,
        'createdAt': Timestamp.now(),
        'userId': user.uid,
        'username': userData.data()!['username']
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 234, 235, 236),
            Color.fromARGB(255, 226, 227, 228),
          ],
          begin: AlignmentGeometry.bottomLeft,
          end: AlignmentGeometry.topRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 2, bottom: 12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                decoration: const InputDecoration(labelText: 'Send a message...'),
                controller: _messageController,
              ),
            ),
            IconButton(
              onPressed: _submitMessage, 
              icon: const Icon(Icons.send),
              color: Theme.of(context).colorScheme.primary,
            )
          ],
        ),
      )
    );
  }
}