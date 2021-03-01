import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/filter_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../models/filter.dart';

class FilterWidget extends StatefulWidget {
  final ValueChanged<List<Filter>> onFilter;

  FilterWidget({Key key, this.onFilter}) : super(key: key);

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends StateMVC<FilterWidget> {
  FilterController _con;

  _FilterWidgetState() : super(FilterController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(S.of(context).filter),
                  MaterialButton(
                    onPressed: () {
                      _con.clearFilter();
                    },
                    child: Text(
                      S.of(context).clear,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                child: ListView(
              primary: true,
              shrinkWrap: true,
              children: [
                ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    _con.categories.isEmpty
                        ? CircularLoadingWidget(height: 100)
                        : ExpansionTile(
                            title: Text(S.of(context).category),
                            children:
                                List.generate(_con.categories.length, (index) {
                              return CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                value:
                                    _con.categories.elementAt(index).selected,
                                onChanged: (value) {
                                  _con.onChangeCategoriesFilter(index);
                                },
                                title: Text(
                                  _con.categories.elementAt(index).name,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  maxLines: 1,
                                ),
                              );
                            }),
                            initiallyExpanded: true,
                          ),
                  ],
                ),
                ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    _con.coloursCategories.isEmpty
                        ? Container()
                        : ExpansionTile(
                            title: Text(S.of(context).colors),
                            children: List.generate(
                                _con.coloursCategories.length, (index) {
                              return CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                value: _con.coloursCategories
                                    .elementAt(index)
                                    .selected,
                                onChanged: (value) {
                                  _con.onChangeColoursCategoriesFilter(index);
                                },
                                title: Text(
                                  _con.coloursCategories.elementAt(index).name,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  maxLines: 1,
                                ),
                              );
                            }),
                            initiallyExpanded: true,
                          ),
                  ],
                ),
                ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    _con.shopsCategories.isEmpty
                        ? Container()
                        : ExpansionTile(
                            title: Text(S.of(context).shops),
                            children: List.generate(_con.shopsCategories.length,
                                (index) {
                              return CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                value: _con.shopsCategories
                                    .elementAt(index)
                                    .selected,
                                onChanged: (value) {
                                  _con.onChangeShopsCategoriesFilter(index);
                                },
                                title: Text(
                                  _con.shopsCategories.elementAt(index).name,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  maxLines: 1,
                                ),
                              );
                            }),
                            initiallyExpanded: true,
                          ),
                  ],
                ),
                ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    _con.shopsCategories.isEmpty
                        ? Container()
                        : ExpansionTile(
                            title: Text(S.of(context).size),
                            children: List.generate(_con.sizesCategories.length,
                                (index) {
                              return CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                value: _con.sizesCategories
                                    .elementAt(index)
                                    .selected,
                                onChanged: (value) {
                                  _con.onChangeSizeCategoriesFilter(index);
                                },
                                title: Text(
                                  _con.sizesCategories.elementAt(index).name,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  maxLines: 1,
                                ),
                              );
                            }),
                            initiallyExpanded: true,
                          ),
                  ],
                ),
              ],
            )),
            SizedBox(height: 15),
            FlatButton(
              onPressed: () {
                _con.saveFilter().whenComplete(() {
                  widget.onFilter(_con.filter);
                });
              },
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              color: Theme.of(context).accentColor,
              shape: StadiumBorder(),
              child: Text(
                S.of(context).apply_filters,
                textAlign: TextAlign.start,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            SizedBox(height: 15)
          ],
        ),
      ),
    );
  }
}
