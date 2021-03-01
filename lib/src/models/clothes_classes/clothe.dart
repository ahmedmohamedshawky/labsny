
import 'clothes.dart';

class Clothe {

  bool success;
  List<Clothes> data;
  String message;

	Clothe.fromJsonMap(Map<String, dynamic> map):
		success = map["success"],
		data = List<Clothes>.from(map["data"].map((it) => Clothes.fromJSON(it))),
		message = map["message"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['success'] = success;
		data['data'] = data != null ? 
			this.data.map((v) => v.toJson()).toList()
			: null;
		data['message'] = message;
		return data;
	}
}
