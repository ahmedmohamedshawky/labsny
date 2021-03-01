import 'package:flutter/material.dart';
import '../models/clothes_classes/offers.dart';
import '../models/clothes_classes/shop.dart';
import '../repository/offer_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class OffersController extends ControllerMVC {
  List<Offers> offers = <Offers>[];

  GlobalKey<ScaffoldState> scaffoldKey;

  OffersController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForOffers();
  }

  Future<void> listenForOffers() async {
    final Stream<Offers> stream = await getOffers();
    stream.listen((Offers _shop) {
      setState(() => offers.add(_shop));
    }, onError: (a) {}, onDone: () {});
  }

  Future<void> refreshOffers() async {
    setState(() {
      ///////////
      offers = <Offers>[];
    });

    await listenForOffers();
  }
}
