import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/src/elements/CardOfferWidget.dart';
import 'package:food_delivery_app/src/elements/CardsCarouselLoaderVerticalWidget.dart';
import 'package:food_delivery_app/src/elements/CardsCarouselLoaderWidget.dart';
import 'package:food_delivery_app/src/models/route_argument.dart';
import '../models/clothes_classes/offers.dart';

 // ignore: must_be_immutable
 class  CardsOffersWidget extends StatefulWidget {

  List<Offers> offers;
  String heroTag;

  CardsOffersWidget({Key key, this.offers, this.heroTag}) : super(key: key);

  @override
  _CardsOffersWidgetState createState() => _CardsOffersWidgetState();
}

class _CardsOffersWidgetState extends State< CardsOffersWidget> {

  @override
  Widget build(BuildContext context) {
    return widget.offers.isEmpty
        ? CardsCarouselLoaderVerticalWidget()
        : Container(
       child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: widget.offers.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/Details',
                  arguments: RouteArgument(
                    id: '0',
                    param: widget.offers.elementAt(index).id,
                    heroTag: widget.heroTag,
                  ));
            },
            child: CardOffersWidget(shop: widget.offers.elementAt(index), heroTag: widget.heroTag),
          );
        },
      ),
    );
  }
}
