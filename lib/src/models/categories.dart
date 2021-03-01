/// success : true
/// data : [{"id":1,"name":"woman","description":"Similique non ut est adipisci. Et repudiandae et eligendi aliquid maiores eaque. Molestiae ratione rerum numquam eaque. Saepe nam magnam placeat amet explicabo aut provident officiis. Et rerum aut maiores aut autem.","created_at":"2021-02-02 17:38:55","updated_at":"2021-02-02 17:38:55"},{"id":2,"name":"men","description":"Ut libero odit inventore aspernatur minima eum iure sequi. Maxime nemo eum natus soluta est est. Cum impedit atque dolorum blanditiis magni aut. Repellat est quibusdam alias autem dolores. Consequuntur dicta consequuntur consequuntur quia voluptas nesciunt dignissimos.","created_at":"2021-02-02 17:38:55","updated_at":"2021-02-02 17:38:55"},{"id":3,"name":"men","description":"Eos fugit eaque rerum esse. Sequi dolor velit asperiores enim et. In beatae in saepe rerum fuga. Quia voluptas aut nulla et ipsa. Eum eum et qui at similique repudiandae sint.","created_at":"2021-02-02 17:38:55","updated_at":"2021-02-02 17:38:55"},{"id":4,"name":"woman","description":"Ullam aut ut quia libero distinctio et. Eum voluptatum omnis unde porro nam itaque eum aut. Cum aspernatur sequi distinctio dolorum eligendi omnis. Voluptas perspiciatis voluptatem consectetur quo. Officia accusantium voluptatibus eaque id.","created_at":"2021-02-02 17:38:55","updated_at":"2021-02-02 17:38:55"},{"id":5,"name":"men","description":"Rem dolorem fuga eaque ut nesciunt. Impedit odit occaecati magni dignissimos vel eum illo. Et sint adipisci impedit ex maxime. Repellat explicabo eos sit in aliquam aut. Amet inventore dolore in eum est nesciunt tenetur.","created_at":"2021-02-02 17:38:55","updated_at":"2021-02-02 17:38:55"},{"id":6,"name":"men","description":"Voluptas recusandae corrupti vel. Voluptatibus praesentium non aut cum et vel deserunt. Quos officiis error et. Eum occaecati ut porro maiores. Quisquam accusantium voluptas possimus autem et.","created_at":"2021-02-02 17:38:55","updated_at":"2021-02-02 17:38:55"},{"id":7,"name":"woman","description":"Porro sed occaecati est. Ipsa ut facere omnis molestiae. Praesentium vel nobis a harum est et doloribus. Non asperiores qui unde repellendus atque. Qui numquam voluptas autem dignissimos aut id nihil quia.","created_at":"2021-02-02 17:38:55","updated_at":"2021-02-02 17:38:55"},{"id":8,"name":"men","description":"Tempore ut sunt harum adipisci. Nisi quia eius amet accusantium perferendis adipisci. Iusto aperiam beatae aspernatur. Id aliquam qui rerum necessitatibus et. Sed voluptatum suscipit esse odio laboriosam ut.","created_at":"2021-02-02 17:38:55","updated_at":"2021-02-02 17:38:55"},{"id":9,"name":"woman","description":"Asperiores accusantium tempore quo doloribus error. Nulla laboriosam voluptatem eaque beatae qui nam. Dolores suscipit consequatur eum et molestiae. In qui sed ea ipsam non nesciunt rem. Ratione eos rerum ipsa aliquam repellat non qui iste.","created_at":"2021-02-02 17:38:55","updated_at":"2021-02-02 17:38:55"},{"id":10,"name":"men","description":"Est rerum deleniti nesciunt libero. Eum neque quasi voluptas sit. Quaerat qui accusantium consequatur sit dolorem. Quia sed dolor eveniet aut ducimus sit nostrum. Dicta qui deleniti quia placeat et.","created_at":"2021-02-02 17:38:55","updated_at":"2021-02-02 17:38:55"},{"id":11,"name":"","description":null,"created_at":"2021-02-02 20:00:46","updated_at":"2021-02-02 20:00:46"}]
/// message : "Clothes Category retrieved successfully"



class Categories {
  int _id;
  String _name;
  String _searchFields;
  bool selected = false;
  String _description;
  String _createdAt;
  String _updatedAt;
  int get id => _id;
  String get searchFields => _searchFields;
  String get name => _name;
  String get description => _description;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  Categories(
 ) ;
  Categories.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
    _description = json["description"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
    _searchFields = json["searchFields"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    map["description"] = _description;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    map["searchFields"] = _searchFields;
    return map;
  }

}