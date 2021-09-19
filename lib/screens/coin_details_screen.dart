import 'package:crypto_asset_app/provider/price_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class CoinDetailsScreen extends StatefulWidget {
  final String name;
  final String price;
  CoinDetailsScreen(this.name, this.price);
  @override
  _CoinDetailsScreenState createState() => _CoinDetailsScreenState();
}

class _CoinDetailsScreenState extends State<CoinDetailsScreen> {
  TextEditingController coinCountController = TextEditingController();
  late Box<String> coinsBox;

  @override
  void initState() {
    coinsBox = Hive.box<String>("coins");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Provider.of<PriceProvider>(context).getUSDTPrice();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    final _dollarPrice =
        Provider.of<PriceProvider>(context, listen: false).dollarPrice;
    final double priceInToman =
        (double.parse(_dollarPrice) / 10) * double.parse(widget.price);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.blueGrey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: _deviceSize.height * 0.6,
              width: _deviceSize.width * 0.8,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFF195F58), Color(0xFF06342E)],
                    // colors: [Color(0xFF7F1717), Color(0xFF1D1E33)],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(60),
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        '${widget.name}',
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '${priceInToman.toStringAsFixed(0).toCurrencyString(mantissaLength: 0)} Toman',
                        // '${toman.toCurrencyString(leadingSymbol: MoneySymbols.DOLLAR_SIGN,mantissaLength: 1)}',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '${widget.price.toCurrencyString(leadingSymbol: MoneySymbols.DOLLAR_SIGN, mantissaLength: 1)}',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CupertinoButton.filled(
                              child: Text(
                                'Add Coin to Assets',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: _showDialog),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                      top: -(_deviceSize.width * 0.05),
                      left: -(_deviceSize.width * 0.05),
                      child: Container(
                        height: _deviceSize.width * 0.2,
                        width: _deviceSize.width * 0.2,
                        decoration: BoxDecoration(
                          color: Color(0xFF2C6C62),
                          shape: BoxShape.circle,
                        ),
                        child: FittedBox(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('Etherium',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showDialog() async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey,
          contentPadding: const EdgeInsets.all(16.0),
          content: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Coin Count', hintText: '1.132'),
                  controller: coinCountController,
                ),
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            TextButton(
                child: const Text('Add'),
                onPressed: () {
                  Provider.of<PriceProvider>(context, listen: false).addCoin(
                      CoinAssets(
                          coinName: widget.name,
                          coinCount: double.parse(coinCountController.text),
                          coinPrice: double.parse(widget.price)));
                  final key = widget.name;
                  final value = coinCountController.text;

                  coinsBox.put(key, value);
                  Navigator.pop(context);
                })
          ],
        );
      },
    );
  }
}
