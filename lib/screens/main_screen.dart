import 'package:crypto_asset_app/provider/price_provider.dart';
import 'package:crypto_asset_app/screens/asset_details_screen.dart';
import 'package:crypto_asset_app/widgets/crypto_price_widget.dart';
import 'package:crypto_asset_app/widgets/main_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _isLoading = false;
  var _isInit = true;
  late Box<String> coinsBox;

  @override
  void initState() {
    coinsBox = Hive.box<String>("coins");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      _isLoading = true;
    });
    if (_isInit) {
      Provider.of<PriceProvider>(context).fetchAndSetCoins().then((_) {
        setState(() {
          _isLoading = false;
        });
        _isInit = false;
      });
      Provider.of<PriceProvider>(context).getUSDTPrice();
    }
    super.didChangeDependencies();
  }

  Future<void> _onRefresh() async {
    setState(() {
      Get.snackbar('Refresh', 'Coin Prices Was Update!');
      setState(() {
        Provider.of<PriceProvider>(context, listen: false).fetchAndSetCoins();
        Provider.of<PriceProvider>(context, listen: false).getUSDTPrice();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context).size;
    Map<String, dynamic> _items = Provider.of<PriceProvider>(context).items;
    List<CoinAssets> _coinAssetsItem =
        Provider.of<PriceProvider>(context).assetsItems;
    print('screenItem');
    print(_items);
    print('COIN_ASSET_SIZE');
    print(_coinAssetsItem.length);

    return RefreshIndicator(
      onRefresh: () => _onRefresh(),
      child: Scaffold(
        body: SafeArea(
          child: Container(
            color: Color.fromRGBO(29, 30, 51, 1),
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
                              intensity: 0.5,
                              color: Colors.white,
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
                        color: Color.fromRGBO(235, 235, 235, 1.0),
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
                                  color: Color.fromRGBO(29, 30, 51, 1),
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
                          //                       fontSize: 16, color: Colors.grey),
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
                                    String coinPrice =
                                        Provider.of<PriceProvider>(context)
                                            .currentCoinPrice(key);
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
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              topLeft: Radius.circular(20),
                                            ),
                                          ),
                                          child: ListTile(
                                            onTap: () =>
                                                Get.to(() => AssetDetailsScreen(
                                                      name: key,
                                                      count: value,
                                                      price: coinPrice,
                                                    )),
                                            onLongPress: () {
                                              setState(() {
                                                coinsBox.delete(key);
                                              });
                                            },
                                            leading: Neumorphic(
                                              style: NeumorphicStyle(
                                                shape: NeumorphicShape.flat,
                                                boxShape:
                                                    NeumorphicBoxShape.circle(),
                                                depth: -8,
                                                intensity: 0.5,
                                                lightSource: LightSource.bottom,
                                              ),
                                              child: CircleAvatar(
                                                backgroundColor: Color.fromRGBO(
                                                    235, 235, 235, 1),
                                                child: FittedBox(
                                                  child:
                                                      Text(key.toUpperCase()),
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              key.toUpperCase(),
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            subtitle: Text(value.toString(),
                                                style: TextStyle(
                                                    color: Colors.black)),
                                            trailing: Text(coinPrice,
                                                style: TextStyle(
                                                    color: Colors.black)),
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
            color: Colors.white,
          ),
          backgroundColor: Color.fromRGBO(29, 30, 51, 1),
        ),
      ),
    );
  }
}
