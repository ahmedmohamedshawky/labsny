import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/models/clothes_classes/clothes.dart';

import '../elements/ClotheCarouselItemWidget.dart';
import '../elements/ClothesCarouselLoaderWidget.dart';
import '../models/food.dart';

class ClothesCarouselWidget extends StatelessWidget {
  final List<Clothes> clothesList;
  final String heroTag;

  ClothesCarouselWidget({Key key, this.clothesList, this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return clothesList.isEmpty
        ? ClothesCarouselLoaderWidget()
        : Container(
            height: 210,
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              itemCount: clothesList.length,
              itemBuilder: (context, index) {
                double _marginLeft = 0;
                (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
                return ClothesCarouselItemWidget(
                  heroTag: heroTag,
                  marginLeft: _marginLeft,
                  clothe: clothesList.elementAt(index),
                );
              },
              scrollDirection: Axis.horizontal,
            ));
  }
}
