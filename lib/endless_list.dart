import 'dart:async';
import 'dart:convert' show Base64Decoder;

import 'package:flutter/material.dart';
import 'package:validator/validator.dart';


class EndlessList extends StatefulWidget {
  static _EndlessListState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<_EndlessListState>());
  final buildItemCallback;

  EndlessList(this.buildItemCallback);

  @override
  createState() => new _EndlessListState();
}

class _EndlessListState extends State<EndlessList> {
  List _items = new List();
  int _itemsCount = 1;
  String _currentFilter = "";

  @override
  Widget build(BuildContext context) {
    final filterWidget = FilteredEndlessList.of(context);
    if (_currentFilter != filterWidget.filter) {
      clear();
    }
    _currentFilter = filterWidget.filter;
    return new RefreshIndicator(
        child:
        new ListView.builder(
          key: new Key("aft players list"), // FIXME: random key here
          primary: true,
          itemCount: _itemsCount,
          itemBuilder: (BuildContext context, int index) =>
              widget.buildItemCallback(context, index, _currentFilter),
        ),
        onRefresh: _onRefresh);
  }

  clear() {
    _items.clear();
    _itemsCount = 1;
  }

  Future<Null> _onRefresh() {
    setState(() {
      clear();
    });
    final completer = new Completer<Null>();
    completer.complete();
    return completer.future;
  }
}

class FilteredEndlessList extends InheritedWidget {
  final String filter;

  const FilteredEndlessList({Key key, this.filter, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(FilteredEndlessList old) {
    return filter != old.filter;
  }

  static FilteredEndlessList of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(FilteredEndlessList);
  }
}
