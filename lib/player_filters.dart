import "package:flutter/material.dart";

import "players_list.dart";
import "endless_list.dart";

import "types/player_filter.dart";

abstract class PlayerFilterWidget {
  Widget filterWidgetBuilder(BuildContext context,
      {@required onFilterChanged(PlayerFilter filter)});

  Widget playersListBuilder(BuildContext context,
      {@required PlayerFilter filter});
}

class PlayerFilterByFamilyName implements PlayerFilterWidget {
  Function(PlayerFilter filter) onFilterChangedCallback;

  @override
  Widget filterWidgetBuilder(BuildContext context,
      {@required onFilterChanged(PlayerFilter filter)}) {
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
      {@required PlayerFilter filter}) {
    return new FilteredEndlessList(filter: filter, child: new PlayersList());
  }

  void _onFilterChanged(String newFilter) {
    onFilterChangedCallback(PlayerFilter(lastName: newFilter));
  }
}

class PlayerFilterFavorite implements PlayerFilterWidget {
  final favoritesFilter = new PlayerFilter(isFavorited: true);

  @override
  Widget filterWidgetBuilder(BuildContext context,
      {@required onFilterChanged(PlayerFilter filter)}) {
    return new Text("Favorite Players");
  }

  @override
  Widget playersListBuilder(BuildContext context,
      {@required PlayerFilter filter}) {
    return new FilteredEndlessList(
        filter: favoritesFilter, child: new PlayersList());
  }
}
