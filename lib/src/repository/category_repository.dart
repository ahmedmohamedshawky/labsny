import 'dart:convert';
import 'dart:developer';

import 'package:food_delivery_app/src/models/categories.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/category.dart';
import '../models/filter.dart';

Future<Stream<Category>> getCategories() async {
  Uri uri = Helper.getUri('api/categories');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final String savedEntriesJson = prefs.getString('filter');
  final List<dynamic> entriesD =
      savedEntriesJson != null ? json.decode(savedEntriesJson) : [];
  List<Filter> dEntries =
      entriesD.map((json) => Filter.fromJSON(json)).toList();

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

    uri = uri.replace(queryParameters: _queryParams);
  }


  //_queryParams.addAll(filter.toQuery());
  // uri = uri.replace(queryParameters: _queryParams);

  print(uri);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    log('Request to $uri');

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => Category.fromJSON(data));
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Category.fromJSON({}));
  }
}

Future<Stream<Category>> getCategoriesOfShop(String shopId) async {
  Uri uri = Helper.getUri('api/categories');
  Map<String, dynamic> _queryParams = {'shop_id': shopId};

  uri = uri.replace(queryParameters: _queryParams);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    log('Request to $uri');
    log('Request to $uri');
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => Category.fromJSON(data));
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Category.fromJSON({}));
  }
}

Future<Stream<Category>> getCategory(String id) async {
  final String url =
      '${GlobalConfiguration().getValue('api_base_url')}categories/$id';
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .map((data) => Category.fromJSON(data));
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return new Stream.value(new Category.fromJSON({}));
  }
}
