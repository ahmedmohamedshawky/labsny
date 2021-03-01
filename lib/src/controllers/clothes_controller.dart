import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/models/clothes_classes/clothes.dart';
import 'package:food_delivery_app/src/repository/clothes_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/cart.dart';
import '../models/extra.dart';
import '../models/favorite.dart';
import '../models/food.dart';
import '../repository/cart_repository.dart';

class ClothesController extends ControllerMVC {
  Clothes clothes;
  double quantity = 1;
  double total = 0;
  List<Cart> carts = [];
  Favorite favorite;
  bool loadCart = false;
  GlobalKey<ScaffoldState> scaffoldKey;

  ClothesController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void listenForClothe({String clotheId, String message}) async {
    final Stream<Clothes> stream = await getClothe(clotheId);
    stream.listen((Clothes _clothe) {
      setState(() => clothes = _clothe);
    }, onError: (a) {
      print(a);
      scaffoldKey.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      calculateTotal();
      if (message != null) {
        scaffoldKey.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForFavorite({String clotheId}) async {
    final Stream<Favorite> stream = await isFavoriteClothes(clotheId);
    stream.listen((Favorite _favorite) {
      setState(() => favorite = _favorite);
    }, onError: (a) {
      print(a);
    });
  }

  void listenForCart() async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      carts.add(_cart);
    });
  }
/////////////////........edit hear Cart
  bool isSameShops(Clothes clothe) {
    if (carts.isNotEmpty) {
      return carts[0].clothes?.shop?.id == clothe.shop?.id;
    }
    return true;
  }

  void addToCart(Clothes clothes, {bool reset = false}) async {
    setState(() {
      this.loadCart = true;
    });
    var _newCart = new Cart();
    _newCart.clothes = clothes;
    _newCart.extras = clothes.extras.where((element) => element.checked).toList();
    _newCart.quantity = this.quantity;
    // if Data exist in the cart then increment quantity
    var _oldCart = isExistInCart(_newCart);
    if (_oldCart != null) {
      _oldCart.quantity += this.quantity;
      updateCart(_oldCart).then((value) {
        setState(() {
          this.loadCart = false;
        });
      }).whenComplete(() {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).this_food_was_added_to_cart),
        ));
      });
    } else {
      // the Data doesnt exist in the cart add new one
      addCart(_newCart, reset).then((value) {
        setState(() {
          this.loadCart = false;
        });
      }).whenComplete(() {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).this_food_was_added_to_cart),
        ));
      });
    }
  }

  Cart isExistInCart(Cart _cart) {
    return carts.firstWhere((Cart oldCart) => _cart.isSame(oldCart), orElse: () => null);
  }

  void addToFavorite(Clothes clothe) async {
    var _favorite = new Favorite();
    _favorite.clothes = clothe;
    _favorite.extras = clothe.extras.where((Extra _extra) {
      return _extra.checked;
    }).toList();
    addFavorite(_favorite).then((value) {
      setState(() {
        this.favorite = value;
      });
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).thisFoodWasAddedToFavorite),
      ));
    });
  }

  void removeFromFavorite(Favorite _favorite) async {
    removeFavorite(_favorite).then((value) {
      setState(() {
        this.favorite = new Favorite();
      });
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).thisClotheWasRemovedFromFavorites),
      ));
    });
  }

  Future<void> refreshClothe() async {
    var _id = clothes.id;
    clothes = new Clothes();
    listenForFavorite(clotheId: _id);
    listenForClothe(clotheId: _id, message: S.of(context).clotheRefreshedSuccessfuly);
  }

  void calculateTotal() {
    total = clothes?.price ?? 0;
    clothes?.extras?.forEach((extra) {
      total += extra.checked ? extra.price : 0;
    });
    total *= quantity;
    setState(() {});
  }

  incrementQuantity() {
    if (this.quantity <= 99) {
      ++this.quantity;
      calculateTotal();
    }
  }

  decrementQuantity() {
    if (this.quantity > 1) {
      --this.quantity;
      calculateTotal();
    }
  }
}
