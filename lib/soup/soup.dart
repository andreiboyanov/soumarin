import "package:html/parser.dart" show parse;
import "package:html/dom.dart";

import './element.dart';

class Soup {
  final String html;
  SoupElement body;

  Soup(this.html) {
    final dom = parse(html);
    body = new SoupElement(dom.body);
  }
}
