import 'package:crypto_asset_app/provider/price_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class MainCardWidget extends StatefulWidget {
  @override
  _MainCardWidgetState createState() => _MainCardWidgetState();
}

class _MainCardWidgetState extends State<MainCardWidget> {
  late Box<String> coinsBox;
  Map<String, String> assets = {};

  double calculateAssetsToToman(BuildContext context) {
    double total = 0.0;
    final _dollarPrice =
        Provider.of<PriceProvider>(context, listen: false).dollarPrice;
    Map<String, dynamic> _items = Provider.of<PriceProvider>(context).items;

    for (var i = 0; i < coinsBox.keys.length; i++) {
      String key = coinsBox.keyAt(i);
      String value = coinsBox.getAt(i).toString();
      if (_items[key] != null)
        total += double.parse(value) *
            _items[key] *
            (double.parse(_dollarPrice) / 10);
      assets[key] = value;
    }
    return total;
  }

  double calculateAssetsToDollar(BuildContext context) {
    double total = 0.0;
    final _dollarPrice =
        Provider.of<PriceProvider>(context, listen: false).dollarPrice;
    Map<String, dynamic> _items = Provider.of<PriceProvider>(context).items;

    for (var i = 0; i < coinsBox.keys.length; i++) {
      String key = coinsBox.keyAt(i);
      String value = coinsBox.getAt(i).toString();
      if (_items[key] != null) total += double.parse(value) * _items[key];
      assets[key] = value;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    coinsBox = Hive.box<String>("coins");
    double _totalTomanAsset = calculateAssetsToToman(context);
    double _totalDollarAsset = calculateAssetsToDollar(context);
    return Neumorphic(
      style: NeumorphicStyle(
        border:
            NeumorphicBorder(color: Color.fromRGBO(19, 19, 35, 1), width: 3),
        shape: NeumorphicShape.convex,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(30)),
        depth: -8,
        intensity: 0.75,
        lightSource: LightSource.topRight,
      ),
      child: Container(
        width: _deviceSize.width,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors:
                  // [Color(0xFF0E4B26),
                  [Color.fromRGBO(120, 5, 5, 1.0), Color(0xFF1D1E33)],
              // colors: [Color(0xFF7F1717), Color(0xFF1D1E33)],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight),
          // border: Border.all(color: Color.fromRGBO(19, 19, 35, 1), width: 2),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _totalDollarAsset.toStringAsFixed(0).toCurrencyString(
                    leadingSymbol: MoneySymbols.DOLLAR_SIGN, mantissaLength: 0),
                style: TextStyle(color: Colors.white, fontSize: 32),
              ),
              SizedBox(height: 20),
              Text(
                '${_totalTomanAsset.toStringAsFixed(0).toCurrencyString(mantissaLength: 0)} Toman',
                style: TextStyle(color: Colors.white, fontSize: 20),
              )
            ],
          ),
        ),
      ),
    );
  }
}
