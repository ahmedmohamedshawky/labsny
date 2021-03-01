import 'dart:convert';
import 'dart:io';

import '../models/clothes_classes/offers.dart';
import 'package:http/http.dart' as http;

import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';


Future<Stream<Offers>> getOffers( ) async {
  Uri uri = Helper.getUri('api/offers');
   try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream.transform(utf8.decoder).transform(json.decoder).map((data) => Helper.getData(data)).expand((data) => (data as List)).map((data) {


      return Offers.fromJSON(data);
    });
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    return new Stream.value(new Offers.fromJSON({}));
  }
}


