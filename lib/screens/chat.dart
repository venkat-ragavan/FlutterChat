import 'package:chat_app/widgets/chat_messages.dart';
import 'package:chat_app/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {

  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Chat'),
        foregroundColor: Color.fromARGB(255, 243, 245, 246),
        backgroundColor: Colors.transparent, 
        elevation: 8, 
        flexibleSpace: Container(
          decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 2, 166, 195),
              Color.fromARGB(255, 8, 121, 155),
            ],
            begin: AlignmentGeometry.bottomRight,
            end: AlignmentGeometry.topLeft,
          ),
        ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            }, 
            icon: Icon(
              Icons.exit_to_app,
              color: Color.fromARGB(255, 243, 245, 246),
            )
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 204, 228, 232),
              Color.fromARGB(255, 177, 200, 207),
            ],
            begin: AlignmentGeometry.bottomRight,
            end: AlignmentGeometry.topLeft,
          ),
        ),
        child: Column(
          children: [
            Expanded(child: ChatMessages()),
            NewMessage(),
          ],
        )
      ),
    );
  }
}