import "package:flutter/material.dart";

import "players_list.dart";
import "endless_list.dart";

abstract class PlayerFilter {
  Widget filterWidgetBuilder(BuildContext context,
      {@required onFilterChanged(Map<String, Object> filter)});

  Widget playersListBuilder(BuildContext context,
      {@required Map<String, Object> filter});
}

class PlayerFilterByFamilyName implements PlayerFilter {
  Function(Map<String, Object> filter) onFilterChangedCallback;
  String currentFilter;

  @override
  Widget filterWidgetBuilder(BuildContext context,
      {@required onFilterChanged(Map<String, Object> filter)}) {
    onFilterChangedCallback = onFilterChanged;
    return new TextField(
      autofocus: false,
      onSubmitted: _onFilterChanged,
      decoration: new InputDecoration(
        icon: new Icon(Icons.search),
        hintText: "AFT Players",
      ),
    );
  }

  @override
  Widget playersListBuilder(BuildContext context,
      {@required Map<String, Object> filter}) {
    return new FilteredEndlessList(filter: filter, child: new PlayersList());
  }

  void _onFilterChanged(String newFilter) {
    onFilterChangedCallback(new Map<String, Object>.from({"name": newFilter}));
  }
}
