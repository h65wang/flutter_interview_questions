import 'package:flutter/material.dart';

import 'model/repo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepoProvider(
      create: () => Repo(),
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = RepoProvider.of(context).repo;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('FiQ'),
      ),
      body: ListenableBuilder(
        listenable: repo,
        builder: (BuildContext context, Widget? child) {
          final questions = repo.questions;
          if (questions == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: questions.length,
            itemBuilder: (_, index) {
              final q = questions[index];
              return ListTile(
                title: Text(q.title),
              );
            },
          );
        },
      ),
    );
  }
}
