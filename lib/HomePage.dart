import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bitcoins/coin_data.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currency = 'USD';
  double ethereumRate = 0.0;
  double litecoinRate = 0.0;
  double bitcoinRate = 0.0;

  Future<void> fetchBitcoinRate(String newCurrency) async {
    final response =
        await http.get(Uri.parse('https://blockchain.info/ticker'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey(newCurrency)) {
        setState(() {
          currency = newCurrency;
          bitcoinRate = data[newCurrency]['last'].toDouble();
          // ethereumRate = data[newCurrency]['ETH']['last'].toDouble();
          // litecoinRate = data[newCurrency]['LTC']['last'].toDouble();
        });
      } else {
        print('Currency data for $newCurrency not found in API response.');
      }
    } else {
      print('API call failed with status ${response.statusCode}');
    }
  }

  Future<void> fetchEthereumRate(String newCurrency) async {
    final response = await http.get(
      Uri.parse(
        'https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=$newCurrency',
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey(newCurrency)) {
        setState(() {
          currency = newCurrency;
          ethereumRate = data[currency];
        });
      } else {
        print('Currency data for $currency not found in API response.');
      }
    } else {
      print('API call failed with status ${response.statusCode}');
    }
  }

  Future<void> fetchLitecoinRate(String newCurrency) async {
    final response = await http.get(
      Uri.parse(
        'https://min-api.cryptocompare.com/data/price?fsym=LTC&tsyms=$newCurrency',
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey(newCurrency)) {
        currency = newCurrency;
        setState(() {
          litecoinRate = data[currency];
        });
      } else {
        print('Currency data for $currency not found in API response.');
      }
    } else {
      print('API call failed with status ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BITCOIN TICKETER'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            color: Colors.blue,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bitcoin (BTC) Data:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '1 BTC = ${bitcoinRate.toStringAsFixed(2)} $currency',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.red, // Placeholder color for Litecoin (LTC)
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Litecoin (LTC) Data:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '1 LTC = ${litecoinRate.toStringAsFixed(2)} $currency',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            color: Colors.green,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ethereum (ETH) Data:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '1 ETH = ${ethereumRate.toStringAsFixed(2)} $currency',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          const Spacer(), // Add a spacer to push the blue container to the bottom
          Container(
            color: Colors.blue,
            height: 100,
            child: Center(
              child: DropdownButton<String>(
                style: const TextStyle(color: Colors.black),
                underline: Container(),
                items: currenciesList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  fetchBitcoinRate(newValue!);
                  fetchEthereumRate(newValue);
                  fetchLitecoinRate(newValue);
                },
                value: currency, // Set the initial value
              ),
            ),
          )
        ],
      ),
    );
  }
}
