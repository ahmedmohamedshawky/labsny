import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:food_delivery_app/src/models/clothes_classes/shop.dart';
import 'package:food_delivery_app/src/repository/shop_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../helpers/app_config.dart' as config;
import '../helpers/helper.dart';
import '../helpers/maps_util.dart';
import '../models/address.dart';
import '../models/restaurant.dart';
import '../repository/restaurant_repository.dart';
import '../repository/settings_repository.dart' as sett;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapController extends ControllerMVC {
  Shop currentShop;
  List<Shop> topShop = <Shop>[];
  List<Marker> allMarkers = <Marker>[];
  Address currentAddress;
  Set<Polyline> polylines = new Set();
  CameraPosition cameraPosition;
  MapsUtil mapsUtil = new MapsUtil();
  Completer<GoogleMapController> mapController = Completer();

  void listenForNearShops(Address myLocation, Address areaLocation) async {
    final Stream<Shop> stream = await getNearShops(myLocation, areaLocation);
    stream.listen((Shop _Shop) {
      setState(() {
        topShop.add(_Shop);
      });
      Helper.getMarker(_Shop.toMap() ,0.0).then((marker) {
        setState(() {
          allMarkers.add(marker);
        });
      });
    }, onError: (a) {}, onDone: () {});
  }

  void getCurrentLocation() async {
    try {
      currentAddress = sett.deliveryAddress.value;
      setState(() {
        if (currentAddress.isUnknown()) {
          print("print    isUnknown");
          cameraPosition = CameraPosition(
            target: LatLng(40, 3),
            zoom: 4,
          );
        } else {
          print("print    else");
          cameraPosition = CameraPosition(
            target: LatLng(currentAddress.latitude, currentAddress.longitude),
            zoom: 14.4746,
          );
        }
      });
      print("print    ${currentAddress.latitude}");
      // if (!currentAddress.isUnknown()) {
        Helper.getMyPositionMarker(currentAddress.latitude, currentAddress.longitude).then((marker) {
          print("marker");
          setState(() {
            allMarkers.add(marker);
          });
        });
      // }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
    }
  }

  void getShopLocation() async {
    try {
      currentAddress = await sett.getCurrentLocation();
      setState(() {
        cameraPosition = CameraPosition(
          target: LatLng(double.parse(currentShop.latitude), double.parse(currentShop.longitude)),
          zoom: 14.4746,
        );
      });
      if (!currentAddress.isUnknown()) {
        Helper.getMyPositionMarker(currentAddress.latitude, currentAddress.longitude).then((marker) {
          setState(() {
            allMarkers.add(marker);
          });
        });
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
    }
  }

  Future<void> goCurrentLocation() async {
    final GoogleMapController controller = await mapController.future;

    sett.setCurrentLocation().then((_currentAddress) {
      print("_currentAddress    ${_currentAddress.longitude}");
      print("_currentAddress    ${_currentAddress.latitude}");
      setState(() {
        sett.deliveryAddress.value = _currentAddress;
        currentAddress = _currentAddress;
      });
      Helper.getMyPositionMarker(currentAddress.latitude, currentAddress.longitude).then((marker) {
        setState(() {
          allMarkers.add(marker);
        });
      });
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(currentAddress.latitude, currentAddress.longitude),
        zoom: 14.4746,
      )));
    });
  }

  void getShopsOfArea() async {
    setState(() {
      topShop = <Shop>[];
      Address areaAddress = Address.fromJSON({"latitude": cameraPosition.target.latitude, "longitude": cameraPosition.target.longitude});
      if (cameraPosition != null) {
        listenForNearShops(currentAddress, areaAddress);
      } else {
        listenForNearShops(currentAddress, currentAddress);
      }
    });
  }

  void getDirectionSteps() async {

    currentAddress = await sett.getCurrentLocation();
    print("getDirectionSteps");

    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> result = await polylinePoints?.getRouteBetweenCoordinates(
        "AIzaSyBoqyjP6pHuTM3SfIt031A_pHGu-VxOAjI",
        currentAddress.latitude,
        currentAddress.longitude,
       double.parse( currentShop.latitude),
        double.parse(   currentShop.longitude));
    if (result.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }else {

      print("hosam  else");

    }

    setState(() {
      // create a Polyline instance
      // with an id, an RGB color and the list of LatLng pairs
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: Color.fromARGB(255, 40, 122, 198),
          points: polylineCoordinates);

      // add the constructed polyline as a set of points
      // to the polyline set, which will eventually
      // end up showing up on the map
      polylines.add(polyline);
    });



    // if (!currentAddress.isUnknown()) {
    //   mapsUtil
    //       .get("origin=" +
    //           currentAddress.latitude.toString() +
    //           "," +
    //           currentAddress.longitude.toString() +
    //           "&destination=" +
    //           currentShop.latitude +
    //           "," +
    //           currentShop.longitude +
    //           "&key=${sett.setting.value?.googleMapsKey}")
    //       .then((dynamic res) {
    //     print("_shaimaa  ${res}");
    //     if (res != null) {
    //
    //       List<LatLng> _latLng = res as List<LatLng>;
    //       _latLng?.insert(0, new LatLng(currentAddress.latitude, currentAddress.longitude));
    //       setState(() {
    //         polylines.add(new Polyline(
    //             visible: true,
    //             polylineId: new PolylineId(currentAddress.hashCode.toString()),
    //             points: _latLng,
    //             color: config.Colors().mainColor(0.8),
    //             width: 6));
    //       });
    //     }
    //   });
    // }
  }

  Future refreshMap() async {
    setState(() {
      topShop = <Shop>[];
    });
    listenForNearShops(currentAddress, currentAddress);
  }
}
