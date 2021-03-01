import 'dart:developer';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/slide.dart';

Future<List<Slide>> getSlides() async {
  var headers =
  {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader:'application/json',
  };
  var url = "http://labsny.net/api/slides?with=clothes%3Bshop&search=enabled%3A1&orderBy=order&sortedBy=asc";
  log('Request to $url');
  var response = await http.get(url,headers:headers);
  log('$url response: ${response.body}');
  var obj = jsonDecode(response.body);
  List slidesJson = obj['data'];
  return slidesJson.map((e) => Slide.fromJSON(e)).toList();
}