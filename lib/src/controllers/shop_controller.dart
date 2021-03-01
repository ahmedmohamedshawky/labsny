import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/models/clothes_classes/clothes.dart';
import 'package:food_delivery_app/src/models/clothes_classes/shop.dart';
import 'package:food_delivery_app/src/repository/clothes_repository.dart';
import 'package:food_delivery_app/src/repository/shop_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/category.dart';
import '../models/food.dart';
import '../models/gallery.dart';
import '../models/restaurant.dart';
import '../models/review.dart';
import '../repository/category_repository.dart';
import '../repository/food_repository.dart';
import '../repository/gallery_repository.dart';
import '../repository/restaurant_repository.dart';
import '../repository/settings_repository.dart';

class ShopController extends ControllerMVC {
  Shop shop;
  List<Gallery> galleries = <Gallery>[];
  List<Clothes> clothes = <Clothes>[];
  List<Category> categories = <Category>[];
  List<Clothes> trendingClothes = <Clothes>[];
  List<Clothes> featuredClothes = <Clothes>[];
  List<Review> reviews = <Review>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  ShopController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  Future<dynamic> listenForShop({String id, String message}) async {
    final whenDone = new Completer();
    final Stream<Shop> stream = await getShops(id, deliveryAddress.value);
    stream.listen((Shop _shop) {
      setState(() => shop = _shop);
      return whenDone.complete(_shop);
    }, onError: (a) {
      log(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
      return whenDone.complete(Shop.fromJSON({}));
    }, onDone: () {
      if (message != null) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
        return whenDone.complete(shop);
      }
    });
    return whenDone.future;
  }

  void listenForGalleries(String idShop) async {
    final Stream<Gallery> stream = await getGalleries(idShop);
    stream.listen((Gallery _gallery) {
      setState(() => galleries.add(_gallery));
    }, onError: (a) {}, onDone: () {});
  }

  void listenForShopReviews({String id, String message}) async {
    final Stream<Review> stream = await getShopReviews(id);
    stream.listen((Review _review) {
      setState(() => reviews.add(_review));
    }, onError: (a) {}, onDone: () {});
  }

  void listenForClothes(String idShop, {List<String> categoriesId}) async {
    final Stream<Clothes> stream = await getClothesOfShop(idShop, categories: categoriesId);
    stream.listen((Clothes _clothe) {
      setState(() => clothes.add(_clothe));
    }, onError: (a) {
      log(a);
    }, onDone: () {
      shop..name = clothes.elementAt(0).shop.name;
    });
  }

  void listenForTrendingClothes(String idShop) async {
    final Stream<Clothes> stream = await getTrendingClothesOfShop(idShop);
    stream.listen((Clothes _clothe) {
      setState(() => trendingClothes.add(_clothe));
    }, onError: (a) {
      log(a);
    }, onDone: () {});
  }

  void listenForFeaturedClothes(String idShop) async {
    final Stream<Clothes> stream = await getFeaturedClothesOfShop(idShop);
    stream.listen((Clothes _clothe) {
      setState(() => featuredClothes.add(_clothe));
    }, onError: (a) {
      log(a);
    }, onDone: () {});
  }

  Future<void> listenForCategories(String shopId) async {
    final Stream<Category> stream = await getCategoriesOfShop(shopId);
    stream.listen((Category _category) {
      setState(() => categories.add(_category));
    }, onError: (a) {
      log(a);
    }, onDone: () {
      categories.insert(0, new Category.fromJSON({'id': '0', 'name': S.of(context).all}));
    });
  }

  Future<void> selectCategory(List<String> categoriesId) async {
    clothes.clear();
    listenForClothes(shop.id, categoriesId: categoriesId);
  }

  Future<void> refreshShop() async {
    var _id = shop.id;
    shop = new Shop();
    galleries.clear();
    reviews.clear();
    featuredClothes.clear();
    listenForShop(id: _id, message: S.of(context).shop_refreshed_successfuly);
    listenForShopReviews(id: _id);
    listenForGalleries(_id);
    listenForFeaturedClothes(_id);
  }
}
