import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../controllers/offers_controller.dart';
import '../elements/CardsOffersWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class OffersWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  OffersWidget({Key key, this.parentScaffoldKey}) : super(key: key);
  @override
  _OffersWidgetState createState() => _OffersWidgetState();
}

class _OffersWidgetState extends StateMVC<OffersWidget> {
  String layout = 'grid';

  OffersController _con;

  _OffersWidgetState() : super(OffersController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con.scaffoldKey,
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            S.of(context).offers,
            style: Theme.of(context)
                .textTheme
                .headline6
                .merge(TextStyle(letterSpacing: 1.3)),
          ),
          actions: <Widget>[
            new ShoppingCartButtonWidget(
                iconColor: Theme.of(context).hintColor,
                labelColor: Theme.of(context).accentColor),
          ],
        ),
      body: CardsOffersWidget(offers: _con.offers, heroTag: 'home_top_shops'),
        );
  }
}
