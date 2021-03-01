import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/controllers/shop_controller.dart';
import 'package:food_delivery_app/src/models/clothes_classes/shop.dart';
import 'package:food_delivery_app/src/pages/shop.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/restaurant_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/DrawerWidget.dart';
import '../elements/PermissionDeniedWidget.dart';
import '../models/conversation.dart';
import '../models/restaurant.dart';
import '../models/route_argument.dart';
import '../repository/user_repository.dart';
import 'chat.dart';
import 'map.dart';
import 'menu_list.dart';
import 'restaurant.dart';

class DetailsWidget extends StatefulWidget {
  RouteArgument routeArgument;
  dynamic currentTab;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Widget currentPage;

  DetailsWidget({
    Key key,
    this.currentTab,
  }) {
    if (currentTab != null) {
      if (currentTab is RouteArgument) {
        routeArgument = currentTab;
        currentTab = int.parse(currentTab.id);
      }
    } else {
      currentTab = 0;
    }
  }

  @override
  _DetailsWidgetState createState() {
    return _DetailsWidgetState();
  }
}

class _DetailsWidgetState extends StateMVC<DetailsWidget> {
  ShopController _con;

  _DetailsWidgetState() : super(ShopController()) {
    _con = controller;
  }

  initState() {
    _selectTab(widget.currentTab);
    super.initState();
  }

  @override
  void didUpdateWidget(DetailsWidget oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0:
          _con.listenForShop(id: widget.routeArgument.param).then((value) {
            setState(() {
              _con.shop = value as Shop;
              log(_con.shop.toMap().toString());
              widget.currentPage = ShopWidget(parentScaffoldKey: widget.scaffoldKey, routeArgument: RouteArgument(param: _con.shop));
            });
          });
          break;
        case 1:
          if (currentUser.value.apiToken == null) {
            widget.currentPage = PermissionDeniedWidget();
          } else {/****Image Error******/
          /*  Conversation _conversation = new Conversation(
                _con.shop.users.map((e) {
                  e.image = _con.shop.image;
                  return e;
                }).toList(),
                name: _con.shop.name);*/
           // widget.currentPage = ChatWidget(parentScaffoldKey: widget.scaffoldKey, routeArgument: RouteArgument(id: _con.shop.id, param: _conversation));
          }
          break;
        case 2:
          widget.currentPage = MapWidget(parentScaffoldKey: widget.scaffoldKey, routeArgument: RouteArgument(param: _con.shop));
          break;
        case 3:
          widget.currentPage = MenuWidget(parentScaffoldKey: widget.scaffoldKey, routeArgument: RouteArgument(param: _con.shop));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: widget.scaffoldKey,
        drawer: DrawerWidget(),
        bottomNavigationBar: Container(
          height: 66,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.10), offset: Offset(0, -4), blurRadius: 10)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.store,
                  size: widget.currentTab == 0 ? 28 : 24,
                  color: widget.currentTab == 0 ? Theme.of(context).accentColor : Theme.of(context).focusColor,
                ),
                onPressed: () {
                  this._selectTab(0);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.chat,
                  size: widget.currentTab == 1 ? 28 : 24,
                  color: widget.currentTab == 1 ? Theme.of(context).accentColor : Theme.of(context).focusColor,
                ),
                onPressed: () {
                  this._selectTab(1);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.directions,
                  size: widget.currentTab == 2 ? 28 : 24,
                  color: widget.currentTab == 2 ? Theme.of(context).accentColor : Theme.of(context).focusColor,
                ),
                onPressed: () {
                  this._selectTab(2);
                },
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: StadiumBorder(),
                color: Theme.of(context).accentColor,
                child: Wrap(
                  spacing: 10,
                  children: [
                    Icon(Icons.store, color: Theme.of(context).primaryColor),
                    Text(
                      S.of(context).collection,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        /*
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).accentColor,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          iconSize: 22,
          elevation: 0,
          backgroundColor: Colors.transparent,
          //selectedIconTheme: IconThemeData(size: 28),
          unselectedItemColor: Theme.of(context).focusColor.withOpacity(1),
          currentIndex: widget.currentTab,
          onTap: (int i) {
            this._selectTab(i);
            print(i);
          },
          // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.store),
              title: new Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              title: new Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions),
              title: new Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: Container(
                margin: EdgeInsetsDirectional.only(end: 10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Wrap(
                  spacing: 10,
                  children: [
                    Icon(Icons.restaurant, color: Theme.of(context).primaryColor),
                    Text(
                      S.of(context).menu,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )
                  ],
                ),
              ),
              title: SizedBox(height: 0),
            ),
          ],
        ),*/
        body: widget.currentPage ?? CircularLoadingWidget(height: 400));
  }
}
