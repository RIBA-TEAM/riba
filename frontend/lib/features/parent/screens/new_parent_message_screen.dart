import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewParentMessageScreen extends StatefulWidget {
  final String parentId;
  final String parentName;
  final String studentId;
  final String studentName;

  const NewParentMessageScreen({
    super.key,
    required this.parentId,
    required this.parentName,
    required this.studentId,
    required this.studentName,
  });

  @override
  State<NewParentMessageScreen> createState() => _NewParentMessageScreenState();
}

class _NewParentMessageScreenState extends State<NewParentMessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isSending = false;

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please write a message.')));
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      await FirebaseFirestore.instance.collection('messages').add({
        'sender_id': widget.parentId,
        'sender_role': 'parent',
        'receiver_id': 'teacher1',
        'receiver_role': 'counselor',
        'parent_id': widget.parentId,
        'student_id': widget.studentId,
        'text': text,
        'created_at': FieldValue.serverTimestamp(),
        'is_read': false,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message sent successfully.')),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error while sending: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bgDark = Color(0xFF101C22);
    const primary = Color(0xFF1193D4);
    const tealDeep = Color(0xFF0D4D5E);

    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        backgroundColor: tealDeep,
        title: const Text('New Message'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [tealDeep, primary],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            color: Colors.white.withOpacity(0.92),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Parent: ${widget.parentName}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Student: ${widget.studentName}',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _messageController,
                    maxLines: 6,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Write your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSending ? null : _sendMessage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isSending
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Send Message',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
