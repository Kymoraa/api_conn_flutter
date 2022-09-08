import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      title: 'API Tutorial',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List quotes = [];

  Future<void> _getQuotes() async {
    final url = Uri.parse(Constants.url + Constants.endPoint);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        quotes = data.values.toList().first;
      });
    } else {
      throw Exception('Failed to load quotes.');
    }
  }

  @override
  Widget build(BuildContext context) {
    _getQuotes();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 70,
        title: const Text(
          'Quotes',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
            color: Colors.grey,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ListView.separated(
          itemCount: quotes.length,
          itemBuilder: (BuildContext context, index) {
            return ListTile(
              leading: Container(
                width: 10,
                height: 10,
                alignment: Alignment.topLeft,
                child: const Icon(
                  Icons.bookmarks_outlined,
                  size: 22,
                  color: Colors.green,
                ),
              ),
              title: Text(
                quotes[index]['quote'],
                style: const TextStyle(fontSize: 14),
              ),
              subtitle: Text(
                quotes[index]['author'],
                style: const TextStyle(fontSize: 13),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
        ),
      ),
    );
  }
}
