import 'package:flutter/material.dart';
import 'database_helper.dart';

final dbHelper = DatabaseHelper();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dbHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFlite Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('sqflite'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _insert,
              child: const Text('Insert'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _query,
              child: const Text('Query All'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _update,
              child: const Text('Update'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _delete,
              child: const Text('Delete'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _queryById,
              child: const Text('Query by ID'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _deleteAll,
              child: const Text('Delete All'),
            ),
          ],
        ),
      ),
    );
  }

  void _insert() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: 'Alice',
      DatabaseHelper.columnAge: 25
    };
    final id = await dbHelper.insert(row);
    debugPrint('Inserted row id: $id');
    if (id == null) {
      debugPrint("Insert failed.");
    }
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    if (allRows.isEmpty) {
      debugPrint('No rows found.');
    } else {
      debugPrint('Query all rows:');
      for (final row in allRows) {
        debugPrint(row.toString());
      }
    }
  }

  void _update() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: 1,
      DatabaseHelper.columnName: 'John',
      DatabaseHelper.columnAge: 30
    };
    final rowsAffected = await dbHelper.update(row);
    debugPrint('Updated $rowsAffected row(s)');
    if (rowsAffected == 0) {
      debugPrint('No rows updated.');
    }
  }

  void _delete() async {
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    debugPrint('Deleted $rowsDeleted row(s): row $id');
    if (rowsDeleted == 0) {
      debugPrint('No rows deleted.');
    }
  }

  void _queryById() async {
    int id = 1; // Change this ID based on what you want to find
    final result = await dbHelper.queryById(id);
    if (result != null) {
      debugPrint('Query result: $result');
    } else {
      debugPrint('No record found with ID $id');
    }
  }

  void _deleteAll() async {
    final rowsDeleted = await dbHelper.deleteAll();
    debugPrint('Deleted all $rowsDeleted row(s)');
    if (rowsDeleted == 0) {
      debugPrint('No rows to delete.');
    }
  }
}