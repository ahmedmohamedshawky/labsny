import 'package:food_delivery_app/src/models/clothes_classes/clothes.dart';
import 'package:food_delivery_app/src/models/clothes_classes/shop.dart';
import 'package:food_delivery_app/src/repository/clothes_repository.dart';
import 'package:food_delivery_app/src/repository/shop_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../models/address.dart';
import '../models/food.dart';
import '../models/restaurant.dart';
import '../repository/food_repository.dart';
import '../repository/restaurant_repository.dart';
import '../repository/search_repository.dart';
import '../repository/settings_repository.dart';

class SearchController extends ControllerMVC {
  List<Shop> shops = <Shop>[];
  List<Clothes> clothes = <Clothes>[];

  SearchController() {
    listenForShops();
    listenForClothes();
  }

  void listenForShops({String search}) async {
    if (search == null) {
      search = await getRecentSearch();
    }
    Address _address = deliveryAddress.value;
    final Stream<Shop> stream = await searchShops(search, _address);
    stream.listen((Shop _shop) {
      setState(() => shops.add(_shop));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  void listenForClothes({String search}) async {
    if (search == null) {
      search = await getRecentSearch();
    }
    Address _address = deliveryAddress.value;
    final Stream<Clothes> stream = await searchClothes(search, _address,"");
    stream.listen((Clothes _clothe) {
      setState(() => clothes.add(_clothe));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> refreshSearch(search) async {
    setState(() {
      shops = <Shop>[];
      clothes = <Clothes>[];
    });
    listenForShops(search: search);
    listenForClothes(search: search);
  }

  void saveSearch(String search) {
    setRecentSearch(search);
  }
}
