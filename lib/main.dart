import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=8771f8e5";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.amber),
  ));
}

Future<Map<String, dynamic>> fetchStockPrices() async {
  final response = await http.get(Uri.parse(request));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('ERRO AO CARREGAR VALORES');
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final stockController = TextEditingController();
  double stockPrice = 0.0;

  void _getStockPrice(String name) async {
    try {
      final data = await fetchStockPrices();
      if (data.containsKey('results') && data['results']['stocks'].containsKey(name)) {
        final stockData = data['results']['stocks'][name];
        setState(() {
          stockPrice = stockData['points'];
        });
      } else {
        setState(() {
          stockPrice = 0.0;
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("BUSCA DE VALOR DAS AÇOES"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),
            TextField(
              controller: stockController,
              decoration: const InputDecoration(
                labelText: 'Insira o nome da empresa',
                labelStyle: TextStyle(color: Colors.amber),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final name = stockController.text.trim();
                _getStockPrice(name);
              },
              child: const Text('Consultar Preço'),
            ),
            const SizedBox(height: 20),
            Text(
              'Preço da ação: \$${stockPrice.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.amber, fontSize: 25.0),
            ),
          ],
        ),
      ),
    );
  }
}
