import 'dart:developer';
import 'dart:convert';
import 'dart:io';

import '../models/clothes_classes/shop.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/filter.dart';
import '../models/review.dart';
import '../repository/user_repository.dart';

Future<Stream<Shop>> getNearShops(Address myLocation, Address areaLocation) async {
  Uri uri = Helper.getUri('api/shops');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Filter filter = Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));

   // _queryParams['limit'] = '6';
  if (!myLocation.isUnknown() && !areaLocation.isUnknown()) {
    _queryParams['myLon'] = myLocation.longitude.toString();
    _queryParams['myLat'] = myLocation.latitude.toString();
    _queryParams['areaLon'] = areaLocation.longitude.toString();
    _queryParams['areaLat'] = areaLocation.latitude.toString();
  }
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

 // _queryParams.addAll(filter.toQuery());
   uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    log('Request to $uri');
    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Shop.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Shop.fromJSON({}));
  }
}

Future<Stream<Shop>> getPopularShops(Address myLocation) async {
  Uri uri = Helper.getUri('api/shops');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Filter filter = Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));

  _queryParams['limit'] = '6';
  _queryParams['popular'] = 'all';
  if (!myLocation.isUnknown()) {
    _queryParams['myLon'] = myLocation.longitude.toString();
    _queryParams['myLat'] = myLocation.latitude.toString();
  }
  //_queryParams.addAll(filter.toQuery());

  final String savedEntriesJson = prefs.getString('filter');
  final List<dynamic> entriesD =savedEntriesJson !=null ? json.decode(savedEntriesJson):[];
  List<Filter> dEntries = entriesD.map((json) => Filter.fromJSON(json)).toList();


  if(dEntries.length !=0&& savedEntriesJson!= null){

    String search ="";
    String searchFields ="";
    dEntries.forEach((element) {
      search = element.searchId+",";
    });

    dEntries.forEach((element) {
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
      return Shop.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Shop.fromJSON({}));
  }
}

Future<Stream<Shop>> searchShops(String search, Address address) async {
  Uri uri = Helper.getUri('api/shops');
  Map<String, dynamic> _queryParams = {};
  _queryParams['search'] = 'name:$search;description:$search';
  _queryParams['searchFields'] = 'name:like;description:like';
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
      return Shop.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Shop.fromJSON({}));
  }
}

Future<Stream<Shop>> getShops(String id, Address address) async {
  Uri uri = Helper.getUri('api/shops/$id');
  Map<String, dynamic> _queryParams = {};
  if (!address.isUnknown()) {
    _queryParams['myLon'] = address.longitude.toString();
    _queryParams['myLat'] = address.latitude.toString();
    _queryParams['areaLon'] = address.longitude.toString();
    _queryParams['areaLat'] = address.latitude.toString();
  }
  _queryParams['with'] = 'users';
  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    log('Request to $uri');

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).map((data) => Shop.fromJSON(data));
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Shop.fromJSON({}));
  }
}

Future<Stream<Review>> getShopReviews(String id) async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}shop_reviews?with=user&search=shop_id:$id';
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Review.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(new Review.fromJSON({}));
  }
}

Future<Stream<Review>> getRecentReviews() async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}shop_reviews?orderBy=updated_at&sortedBy=desc&limit=3&with=user';
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {
      return Review.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(new Review.fromJSON({}));
  }
}

Future<Review> addShopReview(Review review, Shop shop) async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}shop_reviews';
  final client = new http.Client();
  review.user = currentUser.value;
  try {
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(review.ofShopToMap(shop)),
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
