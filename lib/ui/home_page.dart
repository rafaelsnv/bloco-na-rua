import 'package:bloco_na_rua/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to the Home Page!'),
            const SizedBox(height: 20),
            // Temporary button for BlockPage - will be removed later
            ElevatedButton(
              onPressed: () {
                context.go(Routes.carnivalBlock);
              },
              child: const Text('toBlockPage'),
            ),
          ],
        ),
      ),
    );
  }
}
