import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search expenses, loans, subscriptions...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 24),
            Text('Global search — coming in Phase 3'),
          ],
        ),
      ),
    );
  }
}
