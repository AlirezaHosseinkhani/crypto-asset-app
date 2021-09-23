import 'package:crypto_asset_app/provider/price_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../constans.dart';

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
    Future.delayed(Duration.zero, () {
      Provider.of<PriceProvider>(context, listen: false).getUSDTPrice();
    });
    coinsBox = Hive.box<String>("coins");
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   Provider.of<PriceProvider>(context).getUSDTPrice();
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    final _dollarPrice =
        Provider.of<PriceProvider>(context, listen: false).dollarPrice;
    final double priceInToman =
        (double.parse(_dollarPrice) / 10) * double.parse(widget.price);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: KWhiteColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: KMainBackgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: _deviceSize.height * 0.6,
              width: _deviceSize.width * 0.8,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [KMainCardWidgetBlueColor, KMainCardWidgetRedColor],
                    // colors: [Color(0xFF7F1717), Color(0xFF1D1E33)],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft),
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
                        '${widget.name.toUpperCase()}',
                        style: KCoinDetailsTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '${priceInToman.toStringAsFixed(0).toCurrencyString(mantissaLength: 0)} Toman',
                        // '${toman.toCurrencyString(leadingSymbol: MoneySymbols.DOLLAR_SIGN,mantissaLength: 1)}',
                        style: KCoinDetailsTextStyle.copyWith(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '${widget.price.toCurrencyString(leadingSymbol: MoneySymbols.DOLLAR_SIGN, mantissaLength: 3)}',
                        style: KWhiteTextStyle.copyWith(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CupertinoButton.filled(
                              child: Text(
                                'Add Coin to Assets',
                                style: KWhiteTextStyle,
                              ),
                              onPressed: _showDialog),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                      top: -(_deviceSize.width * 0.05),
                      left: -(_deviceSize.width * 0.05),
                      child: Neumorphic(
                          style: NeumorphicStyle(
                            shape: NeumorphicShape.concave,
                            boxShape: NeumorphicBoxShape.circle(),
                            depth: 4,
                            intensity: 0.5,
                            lightSource: LightSource.bottomRight,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: KMainCardWidgetRedColor,
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              height: _deviceSize.width * 0.2,
                              width: _deviceSize.width * 0.2,
                              decoration: BoxDecoration(
                                color: KMainCardWidgetRedColor,
                                shape: BoxShape.circle,
                              ),
                              child: FittedBox(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(widget.name.toUpperCase(),
                                      style: KCoinDetailsTextStyle),
                                ),
                              ),
                            ),
                          ))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showDialog() async {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Add Coin", textAlign: TextAlign.left),
        ),
        content: CupertinoTextField(
          maxLines: 1,
          keyboardType: TextInputType.number,
          controller: coinCountController,
          placeholder: "Enter Coin Count",
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          CupertinoDialogAction(
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
              Navigator.pop(context);
              Get.snackbar('Successful', 'Coin was added',
                  colorText: KWhiteColor);
            },
            child: Text(
              "Add",
            ),
          )
        ],
      ),
    );
  }
}
