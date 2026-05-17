import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String? errorMessage;

  const ErrorScreen({super.key, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 80),
              const SizedBox(height: 20),
              Text(
                errorMessage ?? 'An unexpected error occurred.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // TO-DO: Implement navigation back or retry logic
                  Navigator.of(context).pop();
                },
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
