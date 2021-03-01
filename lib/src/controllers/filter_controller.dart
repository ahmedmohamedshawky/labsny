import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/filter.dart';
import '../models/categories.dart';
import '../repository/filtter_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart.dart';

class FilterController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  List<Categories> categories = <Categories>[];
  List<Categories> coloursCategories = <Categories>[];
  List<Categories> shopsCategories = <Categories>[];
  List<Categories> sizesCategories = <Categories>[];
  List<Filter> filter = [];
  Cart cart;

  FilterController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForFilter().whenComplete(() {
      listenForCategories().whenComplete(() {});
    });
  }

  Future<void> listenForCategories() async {
    final Stream<Categories> stream = await getCategories();
    stream.listen((Categories _shop) {
      if (filter.length > 0)
        filter.forEach((element) {
          if (element.searchId == _shop.id.toString() &&
              element.searchFields == 'category') {
            _shop.selected = true;
          }
        });
      setState(() => categories.add(_shop));
    }, onError: (a) {}, onDone: () {});

    final Stream<Categories> streamColoursCategories =
        await getColoursCategories();
    streamColoursCategories.listen((Categories _shop) {
      if (filter.length > 0)
        filter.forEach((element) {
          if (element.searchId == _shop.id.toString() &&
              element.searchFields == 'color') {
            _shop.selected = true;
          }
        });
      setState(() => coloursCategories.add(_shop));
    }, onError: (a) {}, onDone: () {});

    final Stream<Categories> streamShopsCategories = await getShopsCategories();
    streamShopsCategories.listen((Categories _shop) {
      if (filter.length > 0)
        filter.forEach((element) {
          if (element.searchId == _shop.id.toString() &&
              element.searchFields == 'shops') {
            _shop.selected = true;
          }
        });
      setState(() => shopsCategories.add(_shop));
    }, onError: (a) {}, onDone: () {});

    final Stream<Categories> streamSizesCategories = await getSizesCategories();
    streamSizesCategories.listen((Categories _shop) {
      if (filter.length > 0)
        filter.forEach((element) {
          if (element.searchId == _shop.id.toString() &&
              element.searchFields == 'size') {
            _shop.selected = true;
          }
        });
      setState(() => sizesCategories.add(_shop));
    }, onError: (a) {}, onDone: () {});
  }

  Future<void> listenForFilter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String savedEntriesJson = prefs.getString('filter');
    final List<dynamic> entriesDeserialized =
        savedEntriesJson != null ? json.decode(savedEntriesJson) : [];
    List<Filter> dEntries =
        entriesDeserialized.map((json) => Filter.fromJSON(json)).toList();
    setState(() {
      filter.addAll(dEntries);
    });

  }

  Future<void> saveFilter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String entriesJson =
        json.encode(filter.map((entry) => entry.toMap()).toList());
    prefs.setString('filter', entriesJson);
  }

  void clearFilter() async {
    setState(() {
      resetFilterCategories();
      resetFilterColoursCategories();
      resetFilterShopsCategories();
      resetFilterSizeCategories();
      filter.clear();
    });
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    sharedPreference.remove("filter");
  }

  void resetFilterCategories() {
    categories.forEach((Categories _f) {
      _f.selected = false;
    });
  }

  void resetFilterColoursCategories() {
    coloursCategories.forEach((Categories _f) {
      _f.selected = false;
    });
  }

  void resetFilterShopsCategories() {
    shopsCategories.forEach((Categories _f) {
      _f.selected = false;
    });
  }

  void resetFilterSizeCategories() {
    sizesCategories.forEach((Categories _f) {
      _f.selected = false;
    });
  }

  void onChangeCategoriesFilter(int index) {
    setState(() {
      categories.elementAt(index).selected =
          !categories.elementAt(index).selected;

      Filter itme = Filter();
      itme.searchId = categories[index].id.toString();
      itme.searchFields = 'category';
      //itme.searchFields = categories[index].searchFields.toString() ;

      if (categories.elementAt(index).selected) {
        filter.add(itme);
      } else {
        filter.removeWhere((x) {
          return x.searchId == categories[index].id.toString() &&
              x.searchFields == 'category';
        });
      }
    });
  }

  void onChangeColoursCategoriesFilter(int index) {
    setState(() {
      coloursCategories.elementAt(index).selected =
          !coloursCategories.elementAt(index).selected;

      Filter itme = Filter();
      itme.searchId = coloursCategories[index].id.toString();
      itme.searchFields = 'color';
      //itme.searchFields = categories[index].searchFields.toString() ;
      if (coloursCategories.elementAt(index).selected) {
        filter.add(itme);
      } else {
        filter.removeWhere(
            (x) => x.searchId == itme.searchId && x.searchFields == 'color');
      }
    });
  }

  void onChangeShopsCategoriesFilter(int index) {
    setState(() {
      shopsCategories.elementAt(index).selected =
          !shopsCategories.elementAt(index).selected;

      Filter itme = Filter();
      itme.searchId = shopsCategories[index].id.toString();
      itme.searchFields = 'shops';
      //itme.searchFields = categories[index].searchFields.toString() ;
      if (shopsCategories.elementAt(index).selected) {
        filter.add(itme);
      } else {
        filter.removeWhere(
            (x) => x.searchId == itme.searchId && x.searchFields == 'shops');
      }
    });
  }

  void onChangeSizeCategoriesFilter(int index) {
    setState(() {
      sizesCategories.elementAt(index).selected =
          !sizesCategories.elementAt(index).selected;

      Filter itme = Filter();
      itme.searchId = sizesCategories[index].id.toString();
      itme.searchFields = 'size';
      //itme.searchFields = categories[index].searchFields.toString() ;
      if (sizesCategories.elementAt(index).selected) {
        filter.add(itme);
      } else {
        filter.removeWhere(
            (x) => x.searchId == itme.searchId && x.searchFields == 'size');
      }
    });
  }
}
