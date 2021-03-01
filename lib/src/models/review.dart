import 'package:food_delivery_app/src/models/clothes_classes/clothes.dart';

import '../helpers/custom_trace.dart';
import '../models/food.dart';
import '../models/restaurant.dart';
import '../models/user.dart';
import 'clothes_classes/shop.dart';

class Review {
  String id;
  String review;
  String rate;
  User user;

  Review();
  Review.init(this.rate);

  Review.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      review = jsonMap['review'];
      rate = jsonMap['rate'].toString() ?? '0';
      user = jsonMap['user'] != null ? User.fromJSON(jsonMap['user']) : User.fromJSON({});
    } catch (e) {
      id = '';
      review = '';
      rate = '0';
      user = User.fromJSON({});
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["review"] = review;
    map["rate"] = rate;
    map["user_id"] = user?.id;
    return map;
  }

  @override
  String toString() {
    return this.toMap().toString();
  }

  Map ofShopToMap(Shop shop) {
    var map = this.toMap();
    map["shop_id"] = shop.id;
    return map;
  }
  // Map ofRestaurantToMap(Restaurant restaurant) {
  //   var map = this.toMap();
  //   map["restaurant_id"] = restaurant.id;
  //   return map;
  // }

  Map ofClothesToMap(Clothes clothes) {
    var map = this.toMap();
    map["clothes_id"] = clothes.id;
    return map;
  }
  // Map ofFoodToMap(Food food) {
  //   var map = this.toMap();
  //   map["food_id"] = food.id;
  //   return map;
  // }

  @override
  bool operator ==(dynamic other) {
    return other.id == this.id;
  }

  @override
  int get hashCode => this.id.hashCode;
}
