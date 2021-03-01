import 'package:food_delivery_app/src/models/clothes_classes/size_category.dart';

class Clothes_sizes {

  int id;
  int clothes_id;
  int size_id;
  String created_at;
  String updated_at;
  List<Size_category> size_category;

	Clothes_sizes.fromJsonMap(Map<String, dynamic> map): 
		id = map["id"],
		clothes_id = map["clothes_id"],
		size_id = map["size_id"],
		created_at = map["created_at"],
		updated_at = map["updated_at"],
		size_category = List<Size_category>.from(map["size_category"].map((it) => Size_category.fromJsonMap(it)));

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = id;
		data['clothes_id'] = clothes_id;
		data['size_id'] = size_id;
		data['created_at'] = created_at;
		data['updated_at'] = updated_at;
		data['size_category'] = size_category != null ? 
			this.size_category.map((v) => v.toJson()).toList()
			: null;
		return data;
	}
}
