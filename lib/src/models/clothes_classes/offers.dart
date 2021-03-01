import 'package:food_delivery_app/src/helpers/custom_trace.dart';

import '../user.dart';

class Offers {
  Offers();
  String id;
  String shop_id;
  String manager_id;
  String name;
  String description;
  String address;
  String latitude;
  String longitude;
  String phone;
  String mobile;
  String information;
  double admin_commission;
  double delivery_fee;
  double delivery_range;
  double default_tax;
  bool closed;
  bool active;
  double distance;
  bool available_for_delivery;
  String created_at;
  String updated_at;
  List<Object> custom_fields;
  bool has_media;
  String rate;
  String image;
  List<Object> media;
  List<User> users;

  Offers.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      shop_id = jsonMap['shop_id'].toString();
      manager_id = jsonMap['manager_id'].toString();
      name = jsonMap['name'].toString();
      image = jsonMap['media'][0]['url'].toString();
      description = jsonMap["description"];
      address = jsonMap["address"];
      latitude = jsonMap["latitude"];
      longitude = jsonMap["longitude"];
      phone = jsonMap["phone"];
      mobile = jsonMap["mobile"];
      information = jsonMap["information"];
      admin_commission = jsonMap['admin_commission'] != null
          ? jsonMap['admin_commission'].toDouble()
          : 0.0;
      delivery_fee = jsonMap['delivery_fee'] != null
          ? jsonMap['delivery_fee'].toDouble()
          : 0.0;
      delivery_range = jsonMap['delivery_range'] != null
          ? jsonMap['delivery_range'].toDouble()
          : 0.0;
      default_tax = jsonMap['default_tax'] != null
          ? jsonMap['default_tax'].toDouble()
          : 0.0;
      closed = jsonMap['closed'] ?? false;
      active = jsonMap["active"];
      available_for_delivery = jsonMap['available_for_delivery'] ?? false;
      distance = jsonMap['distance'] != null
          ? double.parse(jsonMap['distance'].toString())
          : 0.0;
      created_at = jsonMap["created_at"];
      updated_at = jsonMap["updated_at"];
      custom_fields = jsonMap["custom_fields"];
      has_media = jsonMap["has_media"];
      rate = jsonMap["rate"];
      media = jsonMap["media"];
      users = jsonMap['users'] != null && (jsonMap['users'] as List).length > 0
          ? List.from(jsonMap['users'])
              .map((element) => User.fromJSON(element))
              .toSet()
              .toList()
          : [];
    } catch (e) {
      id = '';
      shop_id = '';
      manager_id = '';
      name = '';
      //media = new Media();
      rate = '0.0';
      delivery_fee = 0.0;
      admin_commission = 0.0;
      delivery_range = 0.0;
      address = '';
      description = '';
      phone = '';
      mobile = '';
      default_tax = 0.0;
      information = '';
      latitude = '0';
      longitude = '0';
      closed = false;
      available_for_delivery = false;
      distance = 0.0;
      users = [];
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['shop_id'] = shop_id;
    data['manager_id'] = manager_id;
    data['name'] = name;
    data['description'] = description;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['phone'] = phone;
    data['mobile'] = mobile;
    data['information'] = information;
    data['admin_commission'] = admin_commission;
    data['delivery_fee'] = delivery_fee;
    data['delivery_range'] = delivery_range;
    data['default_tax'] = default_tax;
    data['closed'] = closed;
    data['active'] = active;
    data['available_for_delivery'] = available_for_delivery;
    data['created_at'] = created_at;
    data['updated_at'] = updated_at;
    data['custom_fields'] = custom_fields;
    data['has_media'] = has_media;
    data['rate'] = rate;
    data['media'] = media;
    return data;
  }
}
