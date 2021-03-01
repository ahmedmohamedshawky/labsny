import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/models/clothes_classes/clothes.dart';

import '../models/food.dart';
import '../models/route_argument.dart';

class ClotheGridItemWidget extends StatefulWidget {
  final String heroTag;
  final Clothes clothe;
  final VoidCallback onPressed;

  ClotheGridItemWidget({Key key, this.heroTag, this.clothe, this.onPressed}) : super(key: key);

  @override
  _ClotheGridItemWidgetState createState() => _ClotheGridItemWidgetState();
}

class _ClotheGridItemWidgetState extends State<ClotheGridItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      onTap: () {
        Navigator.of(context).pushNamed('/Clothe', arguments: new RouteArgument(heroTag: this.widget.heroTag, id: this.widget.clothe.id));
      },
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Hero(
                  tag: widget.heroTag + widget.clothe.id,
                  child: Container(
                    decoration: BoxDecoration(/*food image*/
                     // image: DecorationImage(image: NetworkImage(this.widget.clothe.media.thumb), fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text(
                widget.clothe.name,
                style: Theme.of(context).textTheme.bodyText1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2),
              Text(
                widget.clothe.shop.name,
                style: Theme.of(context).textTheme.caption,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
          Container(
            margin: EdgeInsets.all(10),
            width: 40,
            height: 40,
            child: FlatButton(
              padding: EdgeInsets.all(0),
              onPressed: () {
                widget.onPressed();
              },
              child: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              color: Theme.of(context).accentColor.withOpacity(0.9),
              shape: StadiumBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
