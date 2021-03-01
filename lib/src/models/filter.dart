

class Filter {
  String searchId;
  String searchFields;
  Filter();

  Filter.fromJSON(Map<String, dynamic> jsonMap) {
      searchId = jsonMap['searchId'].toString() ;
      searchFields = jsonMap['searchFields'].toString() ;
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['searchId'] = searchId;
    map['searchFields'] = searchFields;
    return map;
  }


}