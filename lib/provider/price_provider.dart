import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CoinPrice {
  final String name;
  final String price;
  CoinPrice({required this.name, required this.price});
}

class CoinAssets {
  String coinName;
  double coinCount;
  double coinPrice;
  CoinAssets(
      {required this.coinName,
      required this.coinCount,
      required this.coinPrice});
}

class PriceProvider with ChangeNotifier {
  Map<String, dynamic> _items = {};
  List<CoinAssets> _assetsItems = [];
  String _tetherPrice = '0';

  Map<String, dynamic> get items {
    return {..._items};
  }

  List<CoinAssets> get assetsItems {
    return [..._assetsItems];
  }

  int get itemCount {
    return _items.length;
  }

  int get assetsItemCount {
    return _assetsItems.length;
  }

  String get dollarPrice {
    return _tetherPrice;
  }

  String currentCoinPrice(String key) {
    return items[key].toString();
  }

  Future<void> fetchAndSetCoins() async {
    const url = 'https://api.nobitex.ir/market/global-stats';
    try {
      final response = await http.post(Uri.parse(url));
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      // final Map<String, dynamic> loadedProducts = {};
      Map<String, dynamic> loaded =
          extractedData['markets']['binance'] as Map<String, dynamic>;
      // print(loaded['etc']);
      _items = Map.fromIterable(
          loaded.keys.where((name) =>
              name == 'btc' ||
              name == 'eth' ||
              name == 'xrp' ||
              name == 'ltc' ||
              name == 'bnb' ||
              name == 'ada' ||
              name == 'trx' ||
              name == 'eos' ||
              name == 'bch' ||
              name == 'etc' ||
              name == 'xlm' ||
              name == 'xmr' ||
              name == 'link' ||
              name == 'usdt'),
          key: (name) => name,
          value: (v) => loaded[v]);
      print('provider');
      print(_items);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addCoin(CoinAssets coinAssets) async {
    final newCoinAsset = CoinAssets(
      coinName: coinAssets.coinName,
      coinCount: coinAssets.coinCount,
      coinPrice: coinAssets.coinPrice,
    );
    _assetsItems.add(newCoinAsset);
    notifyListeners();
  }

  Future<void> getUSDTPrice() async {
    const url = 'https://api.nobitex.ir/v2/trades/USDTIRT';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      _tetherPrice = extractedData['trades'][0]['price'];
      print(_tetherPrice);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
