import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/models/clothes_classes/clothes.dart';
import 'package:food_delivery_app/src/models/clothes_classes/shop.dart';
import 'package:food_delivery_app/src/repository/clothes_repository.dart';
import 'package:food_delivery_app/src/repository/shop_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../helpers/helper.dart';
import '../models/category.dart';
import '../models/food.dart';
import '../models/restaurant.dart';
import '../models/review.dart';
import '../models/slide.dart';
import '../repository/category_repository.dart';
import '../repository/food_repository.dart';
//import '../repository/restaurant_repository.dart';
import '../repository/settings_repository.dart';
import '../repository/slider_repository.dart';

class HomeController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  List<Category> categories = <Category>[];
  List<Slide> slides = <Slide>[];
  List<Restaurant> topRestaurants = <Restaurant>[];
  List<Restaurant> popularRestaurants = <Restaurant>[];
  List<Review> recentReviews = <Review>[];
  List<Food> trendingFoods = <Food>[];

  //Clothes
  List<Shop> topShops =<Shop>[];
  List<Shop> popularShops =<Shop>[];
  List<Clothes> trendingClothes = <Clothes>[];

  HomeController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    /*listenForTopRestaurants();
    listenForSlides();
    listenForTrendingFoods();
    listenForCategories();
    listenForPopularRestaurants();
    listenForRecentReviews();*/
    listenForTopShops();
    listenForSlides();
    listenForTrendingClothes();
    listenForCategories();
    listenForPopularShops();
    listenForRecentReviews();
  }

  Future<void> listenForSlides() async {
    final List<Slide> apiSlides = await getSlides();
      setState(() => slides = apiSlides);
  }

  Future<void> listenForCategories() async {
    final Stream<Category> stream = await getCategories();
    stream.listen((Category _category) {
      setState(() => categories.add(_category));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> listenForTopShops() async {
    final Stream<Shop> stream = await getNearShops(deliveryAddress.value, deliveryAddress.value);
    stream.listen((Shop _shop) {
      setState(() => topShops.add(_shop));
    }, onError: (a) {}, onDone: () {});
  }

  Future<void> listenForPopularShops() async {
    final Stream<Shop> stream = await getPopularShops(deliveryAddress.value);
    stream.listen((Shop _shop) {
      setState(() => popularShops.add(_shop));
    }, onError: (a) {}, onDone: () {});
  }

 /* Future<void> listenForTopRestaurants() async {
    final Stream<Restaurant> stream = await getNearRestaurants(deliveryAddress.value, deliveryAddress.value);
    stream.listen((Restaurant _restaurant) {
      setState(() => topRestaurants.add(_restaurant));
    }, onError: (a) {}, onDone: () {});
  }

  Future<void> listenForPopularRestaurants() async {
    final Stream<Restaurant> stream = await getPopularRestaurants(deliveryAddress.value);
    stream.listen((Restaurant _restaurant) {
      setState(() => popularRestaurants.add(_restaurant));
    }, onError: (a) {}, onDone: () {});
  }*/

  Future<void> listenForRecentReviews() async {
    final Stream<Review> stream = await getRecentReviews();
    stream.listen((Review _review) {
      setState(() => recentReviews.add(_review));
    }, onError: (a) {}, onDone: () {});
  }
///////////
  Future<void> listenForTrendingClothes() async {
    final Stream<Clothes> stream = await getTrendingClothes(deliveryAddress.value);
    stream.listen((Clothes clothes) {
      setState(() => trendingClothes.add(clothes));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }
  /////////////
  /*Future<void> listenForTrendingFoods() async {
    final Stream<Food> stream = await getTrendingFoods(deliveryAddress.value);
    stream.listen((Food _food) {
      setState(() => trendingFoods.add(_food));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }*/

  void requestForCurrentLocation(BuildContext context) {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    setCurrentLocation().then((_address) async {
      deliveryAddress.value = _address;
      await refreshHome();
      loader.remove();
    }).catchError((e) {
      loader.remove();
    });
  }

  Future<void> refreshHome() async {
    setState(() {
      slides = <Slide>[];
      categories = <Category>[];
      topRestaurants = <Restaurant>[];
      popularRestaurants = <Restaurant>[];
      trendingFoods = <Food>[];
      ///////////
      topShops = <Shop>[];
      popularShops = <Shop>[];
      trendingClothes = <Clothes>[];
      /////////
      recentReviews = <Review>[];
    });
    /*await listenForSlides();
    await listenForTopRestaurants();
    await listenForTrendingFoods();
    await listenForCategories();
    await listenForPopularRestaurants();
    await listenForRecentReviews();*/
    await listenForSlides();
    await listenForTopShops();
    await listenForTrendingClothes();
    await listenForCategories();
    await listenForPopularShops();
    await listenForRecentReviews();
  }
}
