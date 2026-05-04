import 'package:flutter/material.dart';

class MeetingPresencesScreen extends StatelessWidget {
  const MeetingPresencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meeting Presences')),
      body: const Center(child: Text('Meeting Presences Screen Content')),
    );
  }
}
