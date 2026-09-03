import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  
  const MessageBubble.first({
    super.key,
    required this.username,
    required this.message,
    required this.isMe,
  }) : isFirstInSequence = true;

  const MessageBubble.next({
    super.key,
    required this.message,
    required this.isMe,
  })  : isFirstInSequence = false,
        username = null;

  final bool isFirstInSequence;
  final String? username;
  final String message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
  
    return Stack(
      children: [
        if (isFirstInSequence)
          Positioned(
              top: 12,
              right: isMe ? 0 : null,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 2, 166, 195),
                      Color.fromARGB(255, 8, 121, 155),
                    ],
                    begin: AlignmentGeometry.bottomRight,
                    end: AlignmentGeometry.topLeft,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 24,
                  foregroundColor: Color.fromARGB(255, 243, 245, 246),
                  child: Text(
                    (username!.isNotEmpty ? "${username!.characters.first}${username!.characters.last}" : "").toUpperCase()
                    ),
                ),
              )
            ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 42),
          child: Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (isFirstInSequence) const SizedBox(height: 16),
                  if (username != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: Text(
                        username!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: (isMe) ? 
                          [
                            Color.fromARGB(255, 2, 166, 195),
                            Color.fromARGB(255, 8, 121, 155),
                          ] : [
                            Color.fromARGB(255, 243, 245, 246),
                            Color.fromARGB(255, 221, 232, 235),
                          ],
                        begin: AlignmentGeometry.bottomRight,
                        end: AlignmentGeometry.topLeft,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: !isMe && isFirstInSequence ? Radius.zero : const Radius.circular(12),
                        topRight: isMe && isFirstInSequence ? Radius.zero : const Radius.circular(12),
                        bottomLeft: const Radius.circular(12),
                        bottomRight: const Radius.circular(12),
                      ),
                    ),
                    constraints: const BoxConstraints(maxWidth: 200),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                    child: Text(
                      message,
                      style: TextStyle(
                        height: 1.2,
                        color: isMe ? theme.colorScheme.onSecondary : Colors.black87,
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
