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
      backgroundColor: KMainStatusBarColor,
      appBar: AppBar(
        backgroundColor: KTransparentAppbarColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: KWhiteColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
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
                      colors: [
                        KMainCardWidgetBlueColor,
                        KMainCardWidgetRedColor
                      ],
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Neumorphic(
                          style: NeumorphicStyle(
                            color: KCoinTileColor,
                            shape: NeumorphicShape.flat,
                            boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(5),
                                  bottomLeft: Radius.circular(5)),
                            ),
                            depth: -2,
                            intensity: 0.7,
                            lightSource: LightSource.topLeft,
                          ),
                          child: Container(
                            width: _deviceSize.width * 0.65,
                            height: _deviceSize.height * 0.15,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: FittedBox(
                                    child: Text(
                                      '${priceInToman.toStringAsFixed(0).toCurrencyString(mantissaLength: 0)} Toman',
                                      style: KCoinDetailsTextStyle.copyWith(
                                          fontSize: 20),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                SizedBox(height: _deviceSize.height * 0.03),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: _deviceSize.width * 0.65,
                                    decoration: BoxDecoration(
                                        color: Colors.white10,
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(5),
                                            bottomRight: Radius.circular(5))),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: const Text(
                                        'Coin Value (Toman)',
                                        style: KAssetCoinScreenSubTextStyle,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Neumorphic(
                          style: NeumorphicStyle(
                            color: KCoinTileColor,
                            shape: NeumorphicShape.flat,
                            boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                  bottomRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20)),
                            ),
                            depth: -2,
                            intensity: 0.7,
                            lightSource: LightSource.topLeft,
                          ),
                          child: Container(
                            width: _deviceSize.width * 0.65,
                            height: _deviceSize.height * 0.15,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      width: _deviceSize.width * 0.65,
                                      decoration: BoxDecoration(
                                          color: Colors.white10,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              topRight: Radius.circular(5))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: const Text(
                                          'Coin Value (\$)',
                                          style: KAssetCoinScreenSubTextStyle,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )),
                                SizedBox(height: _deviceSize.height * 0.03),
                                Center(
                                  child: FittedBox(
                                    child: Text(
                                      double.parse(widget.price) > 10.0
                                          ? '${double.parse(widget.price).toStringAsFixed(0).toCurrencyString(leadingSymbol: MoneySymbols.DOLLAR_SIGN, mantissaLength: 0)}'
                                          : '${double.parse(widget.price).toCurrencyString(leadingSymbol: MoneySymbols.DOLLAR_SIGN, mantissaLength: 2)}',
                                      style: KWhiteTextStyle.copyWith(
                                          fontSize: 20),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: _deviceSize.height * .05),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CupertinoButton.filled(
                                child: FittedBox(
                                  child: const Text(
                                    'Add Coin to Assets',
                                    style: KWhiteTextStyle,
                                  ),
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
                                    child: widget.name.isEmpty
                                        ? Text('-')
                                        : Text(widget.name.toUpperCase(),
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
      ),
    );
  }

  _showDialog() async {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text("Add Coin", textAlign: TextAlign.left),
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
            child: const Text("Cancel"),
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
            child: const Text("Add"),
          )
        ],
      ),
    );
  }
}
