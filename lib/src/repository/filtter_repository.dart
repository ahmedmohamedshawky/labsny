import 'dart:developer';
import 'dart:convert';
import 'dart:io';

import '../models/categories.dart';

import 'package:http/http.dart' as http;

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';


Future<Stream<Categories>> getCategories( ) async {
  Uri uri = Helper.getUri('api/clothes-categories');
   try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    log('Request to $uri');

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {


      return Categories.fromJson(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Categories.fromJson({}));
  }
}


Future<Stream<Categories>> getColoursCategories( ) async {
  Uri uri = Helper.getUri('api/colours-categories');
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    log('Request to $uri');

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {


      return Categories.fromJson(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Categories.fromJson({}));
  }



}


Future<Stream<Categories>> getShopsCategories( ) async {
  Uri uri = Helper.getUri('api/shops-categories');
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    log('Request to $uri');

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder)
        .map((data) => Helper.getData(data)).expand((data) => (data as List))
        .map((data) {
      return Categories.fromJson(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Categories.fromJson({}));
  }
}


Future<Stream<Categories>> getSizesCategories( ) async {
  Uri uri = Helper.getUri('api/sizes-categories');
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    log('Request to $uri');

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder)
        .map((data) => Helper.getData(data)).expand((data) => (data as List))
        .map((data) {
      return Categories.fromJson(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Categories.fromJson({}));
  }
}