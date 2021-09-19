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
  String name;
  String count;
  String price;

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
              width: _deviceSize.width * 0.85,
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
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        color: Color.fromRGBO(15, 15, 26, 0.0),
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
                                  color: Color.fromRGBO(15, 15, 26, 0.6),
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
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
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
                                  color: Color.fromRGBO(15, 15, 26, 0.6),
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
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
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
                                  color: Color.fromRGBO(15, 15, 26, 0.6),
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
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
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
                                    style: TextStyle(color: Colors.white),
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
                                  // Get.dialog(
                                  //   AlertDialog(
                                  //     title: Text("Delete Coin"),
                                  //     content: Text("Are you sure?"),
                                  //     actions: <Widget>[
                                  //       TextButton(
                                  //         child: Text("Cancel"),
                                  //         onPressed: () {
                                  //           Get.back();
                                  //         },
                                  //       ),
                                  //       TextButton(
                                  //         child: Text(
                                  //           "Confirm",
                                  //           style: TextStyle(color: Colors.red),
                                  //         ),
                                  //         onPressed: () {
                                  //           Get.back();
                                  //         },
                                  //       ),
                                  //     ],
                                  //   ),
                                  //   barrierDismissible: false,
                                  // );
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
                          color: Color.fromRGBO(15, 15, 26, 0.6),
                          shape: NeumorphicShape.concave,
                          boxShape: NeumorphicBoxShape.circle(),
                          depth: -8,
                          intensity: 0.5,
                          lightSource: LightSource.bottomRight,
                        ),
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
                              child: Text(widget.name.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
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
}
