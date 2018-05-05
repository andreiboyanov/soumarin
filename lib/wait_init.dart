import 'package:flutter/material.dart';

class WaitInit extends StatelessWidget {
  @override
  build(BuildContext context) {
    return (
        new Center(
          child: new CircularProgressIndicator(),
        )
    );
  }
}
