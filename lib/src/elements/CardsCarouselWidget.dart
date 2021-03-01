import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/models/clothes_classes/shop.dart';

import '../elements/CardsCarouselLoaderWidget.dart';
import '../models/restaurant.dart';
import '../models/route_argument.dart';
import 'CardWidget.dart';

// ignore: must_be_immutable
class CardsCarouselWidget extends StatefulWidget {
  List<Shop> shopsList;
  String heroTag;

  CardsCarouselWidget({Key key, this.shopsList, this.heroTag}) : super(key: key);

  @override
  _CardsCarouselWidgetState createState() => _CardsCarouselWidgetState();
}

class _CardsCarouselWidgetState extends State<CardsCarouselWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override

  Widget build(BuildContext context) {
    return widget.shopsList.isEmpty&&widget.shopsList.length !=null
        ? CardsCarouselLoaderWidget()
        : Container(
            height: 288,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.shopsList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/Details',
                        arguments: RouteArgument(
                          id: '0',
                          param: widget.shopsList.elementAt(index).id,
                          heroTag: widget.heroTag,
                        ));
                  },
                  child: CardWidget(shop: widget.shopsList.elementAt(index), heroTag: widget.heroTag),
                );
              },
            ),
          );
  }
}
