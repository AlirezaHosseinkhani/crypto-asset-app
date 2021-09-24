import 'package:crypto_asset_app/provider/price_provider.dart';
import 'package:crypto_asset_app/screens/asset_details_screen.dart';
import 'package:crypto_asset_app/screens/no_connection_screen.dart';
import 'package:crypto_asset_app/widgets/crypto_price_widget.dart';
import 'package:crypto_asset_app/widgets/main_card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_multi_formatter/formatters/money_input_formatter.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../constans.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // var _isLoading = false;
  var _isInit = true;
  late Box<String> coinsBox;
  String coinPrice = '0';
  List<CoinAssets> _coinAssetsItem = [];
  double coinPriceDouble = 0;

  @override
  void initState() {
    coinsBox = Hive.box<String>("coins");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _getAssetsItems();

    setState(() {
      // _isLoading = true;
    });
    if (_isInit) {
      Provider.of<PriceProvider>(context).fetchAndSetCoins().then((_) {
        setState(() {
          // _isLoading = false;
        });
        _isInit = false;
      });
      Provider.of<PriceProvider>(context).getUSDTPrice();
    }
    super.didChangeDependencies();
  }

  Future<void> _onRefresh() async {
    setState(() {
      Get.snackbar('Refresh', 'Coin Prices Was Update!',
          colorText: KWhiteColor);
      setState(() {
        Provider.of<PriceProvider>(context, listen: false).fetchAndSetCoins();
        Provider.of<PriceProvider>(context, listen: false).getUSDTPrice();
      });
    });
  }

  String _getCoinPrice(String key) {
    String coinPrice = Provider.of<PriceProvider>(context, listen: false)
        .currentCoinPrice(key);
    return coinPrice;
  }

  void _getAssetsItems() {
    _coinAssetsItem =
        Provider.of<PriceProvider>(context, listen: false).assetsItems;
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    Map<String, dynamic> _items = Provider.of<PriceProvider>(context).items;
    // List<CoinAssets> _coinAssetsItem =_getAssetsItems();
    print('screenItem');
    print(_items);
    print('COIN_ASSET_SIZE');
    print(_coinAssetsItem.length);

    return RefreshIndicator(
      onRefresh: () => _onRefresh(),
      child: Scaffold(
        backgroundColor: KMainStatusBarColor,
        body: SafeArea(
          child: Container(
            color: KMainBackgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16),
                        child: NeumorphicText("My Crypto Wallet",
                            style: NeumorphicStyle(
                              depth: 8,
                              intensity: 0.6,
                              color: KWhiteColor,
                            ),
                            textStyle: NeumorphicTextStyle(
                              fontSize: 28,
                            ),
                            textAlign: TextAlign.left),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 6,
                  child: Container(
                    decoration: BoxDecoration(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 24.0),
                            child: MainCardWidget(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          String key = _items.keys.elementAt(index);
                          // return CryptoPriceWidget('f', '12');
                          return CryptoPriceWidget(key, _items[key].toString());
                        },
                        itemCount: _items.length,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: _deviceSize.height * 0.03),
                Flexible(
                  flex: 8,
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                      depth: 4,
                      intensity: 0.5,
                      lightSource: LightSource.bottom,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: KListViewWhiteColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 20),
                          Container(
                            height: 16,
                            child: Container(
                              height: 1,
                              width: 60,
                              decoration: BoxDecoration(
                                  color: KMainBackgroundColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40))),
                            ),
                          ),
                          SizedBox(height: 15),
                          // _coinAssetsItem.isEmpty
                          //     ? Center(
                          //         child: Column(
                          //           children: [
                          //             SizedBox(height: 50),
                          //             RichText(
                          //               textAlign: TextAlign.center,
                          //               text: const TextSpan(
                          //                   text:
                          //                       'There is Nothing to Show!... \n',
                          //                   style: TextStyle(
                          //                       fontSize: 16,
                          //                       color: Colors.grey),
                          //                   children: <TextSpan>[
                          //                     const TextSpan(
                          //                       text:
                          //                           'Add Coin From Above List First',
                          //                       style: TextStyle(
                          //                           fontSize: 16,
                          //                           color: Colors.grey),
                          //                     ),
                          //                   ]),
                          //             ),
                          //           ],
                          //         ),
                          //       )
                          //     :
                          Expanded(
                            child: ValueListenableBuilder(
                              valueListenable: coinsBox.listenable(),
                              builder: (context, Box<String> coins, _) {
                                return ListView.separated(
                                  itemBuilder: (ctx, index) {
                                    final key = coins.keys.toList()[index];
                                    final value = coins.get(key) as String;
                                    String coinPrice = _getCoinPrice(key);
                                    try {
                                      coinPriceDouble = double.parse(coinPrice);
                                    } catch (e) {
                                      coinPriceDouble = 0;
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Neumorphic(
                                        style: NeumorphicStyle(
                                          shape: NeumorphicShape.flat,
                                          boxShape:
                                              NeumorphicBoxShape.roundRect(
                                                  BorderRadius.all(
                                                      Radius.circular(20))),
                                          depth: 4,
                                          intensity: 0.5,
                                          lightSource: LightSource.bottom,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: KWhiteColor,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              topLeft: Radius.circular(20),
                                            ),
                                          ),
                                          child: ListTile(
                                              onTap: () {
                                                coinPrice.toString() == 'null'
                                                    ? Get.to(
                                                        NoConnectionScreen())
                                                    : Get.to(() =>
                                                        AssetDetailsScreen(
                                                          name: key,
                                                          count: value,
                                                          price: coinPrice,
                                                        ));
                                              },
                                              onLongPress: () {
                                                // setState(() {
                                                //   coinsBox.delete(key);
                                                // }
                                                //
                                                // );
                                                showCupertinoDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      CupertinoAlertDialog(
                                                    title: const Text(
                                                        "Delete Coin"),
                                                    content: const Text(
                                                        "Are you sure?"),
                                                    actions: <Widget>[
                                                      CupertinoDialogAction(
                                                        isDefaultAction: true,
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            "Cancel"),
                                                      ),
                                                      CupertinoDialogAction(
                                                        onPressed: () {
                                                          setState(() {
                                                            coinsBox
                                                                .delete(key);
                                                          });
                                                          Get.snackbar(
                                                              'Successful',
                                                              'Coin was Deleted',
                                                              colorText:
                                                                  KWhiteColor);
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                          "Confirm",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                              leading: Neumorphic(
                                                style: NeumorphicStyle(
                                                  shape: NeumorphicShape.flat,
                                                  boxShape: NeumorphicBoxShape
                                                      .circle(),
                                                  depth: -8,
                                                  intensity: 0.5,
                                                  lightSource:
                                                      LightSource.bottom,
                                                ),
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      KMainBackgroundColor,
                                                  child: FittedBox(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 2.0),
                                                      child: Text(
                                                        key.toUpperCase(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white70),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              title: Text(key.toUpperCase(),
                                                  style:
                                                      KMainScreenListviewTextStyle),
                                              subtitle: Text(value.toString(),
                                                  style:
                                                      KMainScreenListviewTextStyle),
                                              trailing:
                                                  // double.parse(coinPrice) > 10.0.
                                                  //     ?
                                                  Text(
                                                      coinPriceDouble > 10.0
                                                          ? double.parse(
                                                                  coinPrice)
                                                              .toStringAsFixed(
                                                                  0)
                                                              .toCurrencyString(
                                                                  leadingSymbol:
                                                                      MoneySymbols
                                                                          .DOLLAR_SIGN,
                                                                  mantissaLength:
                                                                      0)
                                                          : coinPrice.toCurrencyString(
                                                              leadingSymbol:
                                                                  MoneySymbols
                                                                      .DOLLAR_SIGN,
                                                              mantissaLength:
                                                                  2),
                                                      style:
                                                          KMainScreenListviewTextStyle)
                                              // : Text(
                                              //     coinPrice.toCurrencyString(
                                              //         leadingSymbol: MoneySymbols.DOLLAR_SIGN,
                                              //         mantissaLength: 2),
                                              //     style: KMainScreenListviewTextStyle)
                                              ),
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (_, index) =>
                                      Divider(color: Colors.white10),
                                  itemCount: coins.keys.toList().length,
                                  // itemCount: _coinAssetsItem.length,
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _onRefresh(),
          child: Icon(
            Icons.refresh,
            color: KWhiteColor,
          ),
          backgroundColor: KMainBackgroundColor,
        ),
      ),
    );
  }
}
