import 'package:food_delivery_app/src/models/clothes_classes/clothes.dart';

import '../helpers/custom_trace.dart';
import '../models/extra.dart';
import '../models/food.dart';

class Favorite {
  String id;
  Clothes clothes;
  List<Extra> extras;
  String userId;

  Favorite();

  Favorite.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] != null ? jsonMap['id'].toString() : null;
      clothes = jsonMap['clothes'] != null ? Clothes.fromJSON(jsonMap['clothes']) : Clothes.fromJSON({});
    extras = jsonMap['extras'] != null ? List.from(jsonMap['extras']).map((element) => Extra.fromJSON(element)).toList() : null;
    } catch (e) {
      id = '';
      clothes = Clothes.fromJSON({});
      extras = [];
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["clothes_id"] = clothes.id;
    map["user_id"] = userId;
    map["extras"] = extras.map((element) => element.id).toList();
    return map;
  }
}
