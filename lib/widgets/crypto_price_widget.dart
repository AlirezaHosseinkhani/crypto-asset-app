import 'dart:math';

import 'package:crypto_asset_app/screens/coin_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

class CryptoPriceWidget extends StatelessWidget {
  final String _name;
  final String _price;
  CryptoPriceWidget(this._name, this._price);

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Get.to(() => CoinDetailsScreen(_name, _price));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Neumorphic(
          style: NeumorphicStyle(
            border: NeumorphicBorder(
                color: Color.fromRGBO(26, 26, 45, 1.0), width: 1),
            color: Color.fromRGBO(15, 15, 26, 0.6),
            shape: NeumorphicShape.flat,
            boxShape: NeumorphicBoxShape.roundRect(
              BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(20)),
            ),
            depth: -6,
            intensity: 0.25,
            lightSource: LightSource.bottomLeft,
          ),
          child: Container(
            width: _deviceSize.width * 0.35,
            // height: _deviceSize.width * 0.2,
            decoration: BoxDecoration(
                // borderRadius: BorderRadius.all(Radius.circular(10))),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(20))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: randomOpaqueColor(),
                  child: FittedBox(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Text(
                      _name.toUpperCase(),
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
                ),
                Text('$_price \$')
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Color randomOpaqueColor() {
    return Color(Random().nextInt(0xffffffff)).withAlpha(0xff);
  }
}
