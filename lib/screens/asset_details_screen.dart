import 'package:crypto_asset_app/constans.dart';
import 'package:crypto_asset_app/provider/price_provider.dart';
import 'package:crypto_asset_app/screens/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_multi_formatter/formatters/money_input_formatter.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class AssetDetailsScreen extends StatefulWidget {
  final String name;
  final String count;
  final String price;

  AssetDetailsScreen(
      {required this.name, required this.price, required this.count});
  @override
  _AssetDetailsScreenState createState() => _AssetDetailsScreenState();
}

class _AssetDetailsScreenState extends State<AssetDetailsScreen> {
  late Box<String> coinsBox;
  @override
  void initState() {
    coinsBox = Hive.box<String>("coins");
    super.initState();
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: KWhiteColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
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
              width: _deviceSize.width * 0.85,
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
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.0),
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.only(
                              topRight: Radius.circular(60),
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15)),
                        ),
                        depth: 6,
                        intensity: 0.6,
                        lightSource: LightSource.topLeft,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Neumorphic(
                                style: NeumorphicStyle(
                                  color: KAssetBGColor,
                                  shape: NeumorphicShape.flat,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(5),
                                        bottomRight: Radius.circular(5),
                                        bottomLeft: Radius.circular(5)),
                                  ),
                                  depth: 4,
                                  intensity: 0.5,
                                  lightSource: LightSource.topLeft,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: _deviceSize.width * 0.35,
                                      height: _deviceSize.height * 0.15,
                                      child: Center(
                                        child: Text(
                                          '${(double.parse(widget.price) * double.parse(widget.count)).toStringAsFixed(0).toCurrencyString(leadingSymbol: MoneySymbols.DOLLAR_SIGN, mantissaLength: 0)}',
                                          style: KAssetCoinScreenTextStyle,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => Get.to(MainScreen()),
                                      child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            width: _deviceSize.width * 0.35,
                                            decoration: BoxDecoration(
                                                color: Colors.white10,
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Text(
                                                'Total Value (\$)',
                                                style:
                                                    KAssetCoinScreenSubTextStyle,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 5),
                              Neumorphic(
                                style: NeumorphicStyle(
                                  color: KAssetBGColor,
                                  shape: NeumorphicShape.flat,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(5),
                                        bottomLeft: Radius.circular(5)),
                                  ),
                                  depth: 4,
                                  intensity: 0.5,
                                  lightSource: LightSource.topLeft,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: _deviceSize.width * 0.35,
                                      height: _deviceSize.height * 0.15,
                                      child: Center(
                                        child: Text(
                                          // '${widget.count}',
                                          '${widget.count}',
                                          style: KAssetCoinScreenTextStyle,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          width: _deviceSize.width * 0.35,
                                          decoration: BoxDecoration(
                                              color: Colors.white10,
                                              borderRadius: BorderRadius.only(
                                                  topRight:
                                                      Radius.circular(10))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Text(
                                              'Coin Count',
                                              style:
                                                  KAssetCoinScreenSubTextStyle,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Neumorphic(
                                style: NeumorphicStyle(
                                  // border: NeumorphicBorder(
                                  //     color: Color.fromRGBO(26, 26, 45, 1.0),
                                  //     width: 1),
                                  color: KAssetBGColor,
                                  shape: NeumorphicShape.flat,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        topRight: Radius.circular(5),
                                        bottomRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20)),
                                  ),
                                  depth: 4,
                                  intensity: 0.5,
                                  lightSource: LightSource.bottomLeft,
                                ),
                                child: Column(
                                  children: [
                                    Align(
                                        alignment: Alignment.topCenter,
                                        child: Container(
                                          width: (_deviceSize.width * 0.7) + 5,
                                          decoration: BoxDecoration(
                                              color: Colors.white10,
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Text(
                                              'Total Value (Toman)',
                                              style:
                                                  KAssetCoinScreenSubTextStyle,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        )),
                                    Container(
                                      width: (_deviceSize.width * 0.7) + 5,
                                      height: _deviceSize.height * 0.15,
                                      child: Center(
                                        child: Text(
                                          '${(priceInToman * double.parse(widget.count)).toStringAsFixed(0).toCurrencyString(mantissaLength: 0)} Toman',
                                          style: KAssetCoinScreenTextStyle
                                              .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CupertinoButton.filled(
                                child: FittedBox(
                                  child: Text(
                                    'Delete Coin from Assets',
                                    style: KWhiteTextStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                onPressed: () {
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (context) => CupertinoAlertDialog(
                                      title: Text("Delete Coin"),
                                      content: Text("Are you sure?"),
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
                                            coinsBox.delete(widget.name);
                                            Get.snackbar('Successful',
                                                'Coin was Deleted',
                                                colorText: KWhiteColor);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Confirm",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
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
                            height: _deviceSize.width * 0.2,
                            width: _deviceSize.width * 0.2,
                            decoration: BoxDecoration(
                              color: KMainCardWidgetRedColor,
                              shape: BoxShape.circle,
                            ),
                            child: FittedBox(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  widget.name.toUpperCase(),
                                  style: KAssetCoinScreenTextStyle.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
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
}
