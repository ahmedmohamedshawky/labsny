import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/models/clothe_order.dart';
import 'package:food_delivery_app/src/models/clothes_classes/clothes.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/food.dart';
import '../models/order.dart';
import '../models/order_status.dart';
import '../models/review.dart';
import '../repository/clothes_repository.dart' as clothesRepo;
import '../repository/order_repository.dart';
import '../repository/shop_repository.dart' as shopRepo;

class ReviewsController extends ControllerMVC {
  Review shopReview;
  List<Review> clothesReviews = [];
  Order order;
  List<ClothesOrder> clothesOfOrder = [];
  List<OrderStatus> orderStatus = <OrderStatus>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  ReviewsController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    this.shopReview = new Review.init("0");
  }

  void listenForOrder({String orderId, String message}) async {
    final Stream<Order> stream = await getOrder(orderId);
    stream.listen((Order _order) {
      setState(() {
        order = _order;
        clothesReviews = List.generate(order.clothesOrders.length, (_) => new Review.init("0"));
      });
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      getClothesOfOrder();
      if (message != null) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void addClothesReview(Review _review, Clothes _clothe) async {
    clothesRepo.addClothesReview(_review, _clothe).then((value) {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).the_clothe_has_been_rated_successfully),
      ));
    });
  }

  void addShopReview(Review _review) async {
    shopRepo.addShopReview(_review, this.order.clothesOrders[0].clothes.shop).then((value) {
      refreshOrder();
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).the_shop_has_been_rated_successfully),
      ));
    });
  }

  Future<void> refreshOrder() async {
    listenForOrder(orderId: order.id, message: S.of(context).reviews_refreshed_successfully);
  }

  void getClothesOfOrder() {
    this.order.clothesOrders.forEach((_clotheOrder) {
      if (!clothesOfOrder.contains(_clotheOrder.clothes)) {
        clothesOfOrder.add(_clotheOrder);
      }
    });
  }
}
