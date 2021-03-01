import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:food_delivery_app/src/models/categories.dart';
import 'package:food_delivery_app/src/models/clothes_classes/clothes.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/favorite.dart';
import '../models/filter.dart';
import '../models/food.dart';
import '../models/review.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;

Future<Stream<Clothes>> getTrendingClothes(Address address) async {
  Uri uri = Helper.getUri('api/clothes');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  _queryParams['limit'] = '6';
  _queryParams['trending'] = 'week';
  if (!address.isUnknown()) {
    _queryParams['myLon'] = address.longitude.toString();
    _queryParams['myLat'] = address.latitude.toString();
    _queryParams['areaLon'] = address.longitude.toString();
    _queryParams['areaLat'] = address.latitude.toString();
  }
  //_queryParams.addAll(filter.toQuery());

  final String savedEntriesJson = prefs.getString('filter');
  final List<dynamic> entriesD =savedEntriesJson !=null ? json.decode(savedEntriesJson):[];
  List<Filter> dEntries = entriesD.map((json) => Filter.fromJSON(json)).toList();

  if(dEntries.length>0){
    String search ="";
    String searchFields ="";
    dEntries.forEach((element) {
      if(element.searchId!=null)
        search = element.searchId+",";
    });

    dEntries.forEach((element) {
      if(element.searchFields!=null)
        searchFields = element.searchFields+",";
    });
    _queryParams['search'] = search;
    _queryParams['searchFields'] = searchFields;
  }

  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    log('Request to $uri');

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Clothes.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Clothes.fromJSON({}));
  }
}
Future<Stream<Clothes>> getClothe(String clotheId) async{
  Uri uri = Helper.getUri('api/clothes/$clotheId');
  uri = uri.replace(queryParameters: {'with': 'nutrition;shop;category;extras;extraGroups;clothesReviews;clothesReviews.user'});
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    log('Request to $uri');
    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).map((data) {
      return Clothes.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Clothes.fromJSON({}));
  }

}


// shaimaa edit for search here
Future<Stream<Clothes>> searchClothes(String search,Address address ,String searchFields)async{
  Uri uri = Helper.getUri('api/clothes');
  Map<String, dynamic> _queryParams = {};
  _queryParams['search'] = search;
  _queryParams['searchFields'] = searchFields;
  _queryParams['limit'] = '5';
  if (!address.isUnknown()) {
    _queryParams['myLon'] = address.longitude.toString();
    _queryParams['myLat'] = address.latitude.toString();
    _queryParams['areaLon'] = address.longitude.toString();
    _queryParams['areaLat'] = address.latitude.toString();
  }
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    log('Request to $uri');

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Clothes.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Clothes.fromJSON({}));
  }
}
Future<Stream<Clothes>> getClothesByCategory(categoryId) async {
  Uri uri = Helper.getUri('api/clothes');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final String savedEntriesJson = prefs.getString('filter');
  final List<dynamic> entriesD =savedEntriesJson !=null ? json.decode(savedEntriesJson):[];
  List<Filter> dEntries = entriesD.map((json) => Filter.fromJSON(json)).toList();
  if(dEntries.length>0){
    String search ="";
    String searchFields ="";
    dEntries.forEach((element) {
      if(element.searchId!=null)
        search = element.searchId+",";
    });

    dEntries.forEach((element) {
      if(element.searchFields!=null)
        searchFields = element.searchFields+",";
    });
    _queryParams['search'] = search;
    _queryParams['searchFields'] = searchFields;
  }

  //_queryParams = filter.toQuery(oldQuery: _queryParams);
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    log('Request to $uri');

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Clothes.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Clothes.fromJSON({}));
  }
}



Future<Stream<Favorite>> isFavoriteClothes(String clothesId) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}favorites/exist?${_apiToken}clothes_id=$clothesId&user_id=${_user.id}';
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getObjectData(data)).map((data) => Favorite.fromJSON(data));
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(new Favorite.fromJSON({}));
  }
}

Future<Stream<Favorite>> getFavorites() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}favorites?${_apiToken}with=clothes;user;extras&search=user_id:${_user.id}&searchFields=user_id:=';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
  try {
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => Favorite.fromJSON(data));
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(new Favorite.fromJSON({}));
  }
}

Future<Favorite> addFavorite(Favorite favorite) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Favorite();
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  favorite.userId = _user.id;
  final String url = '${GlobalConfiguration().getValue('api_base_url')}favorites?$_apiToken';
  try {
    final client = new http.Client();
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(favorite.toMap()),
    );
    return Favorite.fromJSON(json.decode(response.body)['data']);
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return Favorite.fromJSON({});
  }
}

Future<Favorite> removeFavorite(Favorite favorite) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Favorite();
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}favorites/${favorite.id}?$_apiToken';
  try {
    final client = new http.Client();
    final response = await client.delete(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    return Favorite.fromJSON(json.decode(response.body)['data']);
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return Favorite.fromJSON({});
  }
}

Future<Stream<Clothes>> getClothesOfShop(String shopId, {List<String> categories}) async {
  Uri uri = Helper.getUri('api/clothes/categories');
  Map<String, dynamic> query = {
    'with': 'shop;category;extras;clothesReviews',
    'search': 'shop_id:$shopId',
    'searchFields': 'shop_id:=',
  };

  if (categories != null && categories.isNotEmpty) {
    query['categories[]'] = categories;
  }
  uri = uri.replace(queryParameters: query);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    log('Request to $uri');

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Clothes.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Clothes.fromJSON({}));
  }
}

Future<Stream<Clothes>> getTrendingClothesOfShop(String shopId) async {
  Uri uri = Helper.getUri('api/clothes');
  uri = uri.replace(queryParameters: {
    'with': 'category;extras;clothesReviews',
    'search': 'shop_id:$shopId;featured:1',
    'searchFields': 'shop_id:=;featured:=',
    'searchJoin': 'and',
  });
  // TODO Trending foods only
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    log('Request to $uri');

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Clothes.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Clothes.fromJSON({}));
  }
}

Future<Stream<Clothes>> getFeaturedClothesOfShop(String shopId) async {
  Uri uri = Helper.getUri('api/clothes');
  uri = uri.replace(queryParameters: {
    'with': 'category;extras;clothesReviews',
    'search': 'shop_id:$shopId;featured:1',
    'searchFields': 'shop_id:=;featured:=',
    'searchJoin': 'and',
  });
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    log('Request to $uri');

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Clothes.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Clothes.fromJSON({}));
  }
}

Future<Review> addClothesReview(Review review, Clothes clothe) async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}clothes_reviews';
  final client = new http.Client();
  review.user = userRepo.currentUser.value;
  try {
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(review.ofClothesToMap(clothe)),
    );
    if (response.statusCode == 200) {
      return Review.fromJSON(json.decode(response.body)['data']);
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
      return Review.fromJSON({});
    }
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return Review.fromJSON({});
  }
}
