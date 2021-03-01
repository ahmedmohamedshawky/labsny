import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_delivery_app/src/controllers/shop_controller.dart';
import 'package:food_delivery_app/src/models/clothes_classes/shop.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/restaurant_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/DrawerWidget.dart';
import '../elements/ClotheItemWidget.dart';
import '../elements/ClothesCarouselWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../models/restaurant.dart';
import '../models/route_argument.dart';

class MenuWidget extends StatefulWidget {
  @override
  _MenuWidgetState createState() => _MenuWidgetState();
  final RouteArgument routeArgument;
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  MenuWidget({Key key, this.parentScaffoldKey, this.routeArgument}) : super(key: key);
}

class _MenuWidgetState extends StateMVC<MenuWidget> {
  ShopController _con;
  List<String> selectedCategories;

  _MenuWidgetState() : super(ShopController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.shop = widget.routeArgument.param as Shop;
    _con.listenForTrendingClothes(_con.shop.id);
    _con.listenForCategories(_con.shop.id);
    selectedCategories = ['0'];
    _con.listenForClothes(_con.shop.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      drawer: DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
          onPressed: () => Navigator.of(context).pushNamed('/Details', arguments: RouteArgument(id: '0', param: _con.shop.id, heroTag: 'menu_tab')),
        ),
        title: Text(
          _con.shop?.name ?? '',
          overflow: TextOverflow.fade,
          softWrap: false,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 0)),
        ),
        actions: <Widget>[
          new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchBarWidget(),
            ),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: Icon(
                Icons.bookmark,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                S.of(context).featured_clothes,
                style: Theme.of(context).textTheme.headline4,
              ),
              subtitle: Text(
                S.of(context).clickOnTheClotheToGetMoreDetailsAboutIt,
                maxLines: 2,
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            ClothesCarouselWidget(heroTag: 'menu_trending_clothes', clothesList: _con.trendingClothes),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              leading: Icon(
                Icons.subject,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                S.of(context).all_menu,
                style: Theme.of(context).textTheme.headline4,
              ),
              subtitle: Text(
                S.of(context).clickOnTheClotheToGetMoreDetailsAboutIt,
                maxLines: 2,
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            _con.categories.isEmpty
                ? SizedBox(height: 90)
                : Container(
                    height: 90,
                    child: ListView(
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: List.generate(_con.categories.length, (index) {
                        var _category = _con.categories.elementAt(index);
                        var _selected = this.selectedCategories.contains(_category.id);
                        return Padding(
                          padding: const EdgeInsetsDirectional.only(start: 20),
                          child: RawChip(
                            elevation: 0,
                            label: Text(_category.name),
                            labelStyle: _selected
                                ? Theme.of(context).textTheme.bodyText2.merge(TextStyle(color: Theme.of(context).primaryColor))
                                : Theme.of(context).textTheme.bodyText2,
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                            backgroundColor: Theme.of(context).focusColor.withOpacity(0.1),
                            selectedColor: Theme.of(context).accentColor,
                            selected: _selected,
                            //shape: StadiumBorder(side: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.05))),
                            showCheckmark: false,
                            avatar: (_category.id == '0')
                                ? null
                                : (_category.image.url.toLowerCase().endsWith('.svg')
                                    ? SvgPicture.network(
                                        _category.image.url,
                                        color: _selected ? Theme.of(context).primaryColor : Theme.of(context).accentColor,
                                      )
                                    : CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: _category.image.icon,
                                        placeholder: (context, url) => Image.asset(
                                          'assets/img/loading.gif',
                                          fit: BoxFit.cover,
                                        ),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      )),
                            onSelected: (bool value) {
                              setState(() {
                                if (_category.id == '0') {
                                  this.selectedCategories = ['0'];
                                } else {
                                  this.selectedCategories.removeWhere((element) => element == '0');
                                }
                                if (value) {
                                  this.selectedCategories.add(_category.id);
                                } else {
                                  this.selectedCategories.removeWhere((element) => element == _category.id);
                                }
                                _con.selectCategory(this.selectedCategories);
                              });
                            },
                          ),
                        );
                      }),
                    ),
                  ),
            _con.clothes.isEmpty
                ? CircularLoadingWidget(height: 250)
                : ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _con.clothes.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 10);
                    },
                    itemBuilder: (context, index) {
                      return ClotheItemWidget(
                        heroTag: 'menu_list',
                        clothe: _con.clothes.elementAt(index),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
