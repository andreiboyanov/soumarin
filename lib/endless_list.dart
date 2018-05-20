import 'dart:async';

import 'package:flutter/material.dart';


class EndlessList extends StatefulWidget {
  static _EndlessListState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<_EndlessListState>());
  final buildItemCallback;
  final getNewItemsCallback;

  EndlessList(this.buildItemCallback, this.getNewItemsCallback);

  @override
  createState() => new _EndlessListState();
}

class _EndlessListState extends State<EndlessList> {
  List _items = new List();
  int _itemsCount = 1;
  var _currentFilter = {"name": ""};

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
              _buildItem(context, index, _currentFilter),
        ),
        onRefresh: _onRefresh);
  }

  clear() {
    _items.clear();
    _itemsCount = 1;
  }

  _buildItem(BuildContext context, int index, filter) {
    if (index >= _items.length) {
      widget.getNewItemsCallback(filter: filter, start: _items.length)
          .then((newItems) {
        if (newItems.length > 0) {
          setState(() {
            _items.addAll(newItems);
            _itemsCount = _items.length + 1;
          });
        } else {
          setState(() {
            _itemsCount = _items.length;
          });
        }
      });
      return const Padding(
        padding: const EdgeInsets.all(20.0),
        child: const Center(
          child: const CircularProgressIndicator(),
        ),
      );
    } else {
      return widget.buildItemCallback(context, _items[index]);
    }
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
  final Map<String, Object> filter;

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
