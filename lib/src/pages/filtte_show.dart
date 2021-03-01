import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import '../elements/CardsFilterWidget.dart';
import '../../generated/l10n.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class FilterShow extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  FilterShow({Key key, this.parentScaffoldKey}) : super(key: key);
  @override
  _FilterShowState createState() => _FilterShowState();
}

class _FilterShowState extends StateMVC<FilterShow> {

  HomeController _con;

  _FilterShowState() : super(HomeController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con.scaffoldKey,
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.close, color: Theme.of(context).hintColor),
            onPressed: () {
              Navigator.pop(context);
            },

          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            S.of(context).filter_result,
            style: Theme.of(context)
                .textTheme
                .headline6
                .merge(TextStyle(letterSpacing: 1.3)),
          ),
          // actions: <Widget>[
          //   new ShoppingCartButtonWidget(
          //       iconColor: Theme.of(context).hintColor,
          //       labelColor: Theme.of(context).accentColor),
          // ],
        ),
      body: CardsFilterWidget(shopsList: _con.topShops, heroTag: 'home_top_shops'),
        );
  }
}
