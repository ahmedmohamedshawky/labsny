
import 'package:food_delivery_app/src/helpers/custom_trace.dart';
import 'package:food_delivery_app/src/models/clothes_classes/shop.dart';

import '../category.dart';
import '../extra.dart';
import '../extra_group.dart';
import '../nutrition.dart';
import '../review.dart';
import 'clothes_sizes.dart';

class Clothes {
////////////////id was in
  String id;
  String name;
  double price;
  double discount_price;
  String description;
  Object ingredients;
  String package_items_count;
  String weight;
  String unit;
  bool featured;
  bool deliverable;
  int shop_id;
  String created_at;
  String updated_at;
  List<Object> custom_fields;
  bool has_media;
  Shop shop;
  List<Object> media;
	Category category;
	List<Extra> extras;
	List<ExtraGroup> extraGroups;
	List<Review> clothesReviews;
	List<Nutrition> nutritions;

	Clothes();
	/*Food.fromJSON(Map<String, dynamic> jsonMap) {
		try {
			id = jsonMap['id'].toString();
			name = jsonMap['name'];
			price = jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0.0;
			discountPrice = jsonMap['discount_price'] != null ? jsonMap['discount_price'].toDouble() : 0.0;
			price = discountPrice != 0 ? discountPrice : price;
			discountPrice = discountPrice == 0 ? discountPrice : jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0.0;
			description = jsonMap['description'];
			ingredients = jsonMap['ingredients'];
			weight = jsonMap['weight'] != null ? jsonMap['weight'].toString() : '';
			unit = jsonMap['unit'] != null ? jsonMap['unit'].toString() : '';
			packageItemsCount = jsonMap['package_items_count'].toString();
			featured = jsonMap['featured'] ?? false;
			deliverable = jsonMap['deliverable'] ?? false;
			restaurant = jsonMap['restaurant'] != null ? Restaurant.fromJSON(jsonMap['restaurant']) : Restaurant.fromJSON({});
			category = jsonMap['category'] != null ? Category.fromJSON(jsonMap['category']) : Category.fromJSON({});
			image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0 ? Media.fromJSON(jsonMap['media'][0]) : new Media();
			extras = jsonMap['extras'] != null && (jsonMap['extras'] as List).length > 0
					? List.from(jsonMap['extras']).map((element) => Extra.fromJSON(element)).toSet().toList()
					: [];
			extraGroups = jsonMap['extra_groups'] != null && (jsonMap['extra_groups'] as List).length > 0
					? List.from(jsonMap['extra_groups']).map((element) => ExtraGroup.fromJSON(element)).toSet().toList()
					: [];
			foodReviews = jsonMap['food_reviews'] != null && (jsonMap['food_reviews'] as List).length > 0
					? List.from(jsonMap['food_reviews']).map((element) => Review.fromJSON(element)).toSet().toList()
					: [];
			nutritions = jsonMap['nutrition'] != null && (jsonMap['nutrition'] as List).length > 0
					? List.from(jsonMap['nutrition']).map((element) => Nutrition.fromJSON(element)).toSet().toList()
					: [];
		} catch (e) {
			id = '';
			name = '';
			price = 0.0;
			discountPrice = 0.0;
			description = '';
			weight = '';
			ingredients = '';
			unit = '';
			packageItemsCount = '';
			featured = false;
			deliverable = false;
			restaurant = Restaurant.fromJSON({});
			category = Category.fromJSON({});
			image = new Media();
			extras = [];
			extraGroups = [];
			foodReviews = [];
			nutritions = [];
			print(CustomTrace(StackTrace.current, message: e));
		}
	}*/
  Clothes.fromJSON(Map<String, dynamic> jsonMap){
	  try{
			id = jsonMap['id'].toString();
			name = jsonMap['name'];
			price = jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0.0;
			discount_price = jsonMap['discount_price'] != null ? jsonMap['discount_price'].toDouble() : 0.0;
			price = discount_price != 0 ? discount_price : price;
			discount_price = discount_price == 0 ? discount_price : jsonMap['price'] != null ? jsonMap['price'].toDouble() : 0.0;
			description = jsonMap['description'];
			ingredients = jsonMap['ingredients'];
			weight = jsonMap['weight'] != null ? jsonMap['weight'].toString() : '';
			unit = jsonMap['unit'] != null ? jsonMap['unit'].toString() : '';
			package_items_count = jsonMap['package_items_count'].toString();

			featured = jsonMap['featured'] ?? false;
			deliverable = jsonMap['deliverable'] ?? false;
			shop = jsonMap['shop'] != null ? Shop.fromJSON(jsonMap['shop']) : Shop.fromJSON({});
			category = jsonMap['category'] != null ? Category.fromJSON(jsonMap['category']) : Category.fromJSON({});
			//	image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0 ? Media.fromJSON(jsonMap['media'][0]) : new Media();
			extras = jsonMap['extras'] != null && (jsonMap['extras'] as List).length > 0
					? List.from(jsonMap['extras']).map((element) => Extra.fromJSON(element)).toSet().toList()
					: [];
			extraGroups = jsonMap['extra_groups'] != null && (jsonMap['extra_groups'] as List).length > 0
					? List.from(jsonMap['extra_groups']).map((element) => ExtraGroup.fromJSON(element)).toSet().toList()
					: [];
			clothesReviews = jsonMap['clothe_reviews'] != null && (jsonMap['clothe_reviews'] as List).length > 0
					? List.from(jsonMap['clothe_reviews']).map((element) => Review.fromJSON(element)).toSet().toList()
					: [];
			nutritions = jsonMap['nutrition'] != null && (jsonMap['nutrition'] as List).length > 0
					? List.from(jsonMap['nutrition']).map((element) => Nutrition.fromJSON(element)).toSet().toList()
					: [];

			shop_id = jsonMap["shop_id"];
			created_at = jsonMap["created_at"];
			updated_at = jsonMap["updated_at"];
			custom_fields = jsonMap["custom_fields"];
			has_media = jsonMap["has_media"];
			media = jsonMap["media"];
		}
		catch(e){
			id = '';
			name = '';
			price = 0.0;
			discount_price = 0.0;
			description = '';
			weight = '';
			ingredients = '';
			unit = '';
			package_items_count = '';
			featured = false;
			deliverable = false;
			shop = Shop.fromJSON({});
			category = Category.fromJSON({});
			//image = new Media();
			extras = [];
			extraGroups = [];
			clothesReviews = [];
			nutritions = [];
			print(CustomTrace(StackTrace.current, message: e));
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = id;
		data['name'] = name;
		data['price'] = price;
		data['discount_price'] = discount_price;
		data['description'] = description;
		data['ingredients'] = ingredients;
		data['package_items_count'] = package_items_count;
		data['weight'] = weight;
		data['unit'] = unit;
		data['featured'] = featured;
		data['deliverable'] = deliverable;
		data['shop_id'] = shop_id;
		data['created_at'] = created_at;
		data['updated_at'] = updated_at;
		data['custom_fields'] = custom_fields;
		data['has_media'] = has_media;
		data['shop'] = shop == null ? null : shop.toMap();
		data['media'] = media;
		return data;
	}
}
