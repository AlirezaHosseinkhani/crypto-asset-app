import 'package:crypto_asset_app/constans.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoConnectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: KMainStatusBarColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: KTransparentAppbarColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: KWhiteColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: KMainBackgroundColor,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset(
                'assets/images/no_connection.png',
                color: KWhiteColor,
                height: _deviceSize.width * 0.3,
              ),
              const Text(
                'Please Check Your Internet Connection',
                style: TextStyle(color: KMainWhiteColor),
              ),
              CupertinoButton.filled(
                  child: const Text('Back to Main', style: KWhiteTextStyle),
                  onPressed: () => Navigator.of(context).pop()),
            ],
          )),
        ),
      ),
    );
  }
}
