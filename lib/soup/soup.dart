import "package:html/parser.dart" show parse;
import "package:html/dom.dart";

import './element.dart';

class Soup {
  String html;
  Document dom;

  Soup(this.html) {
    dom = parse(html);
  }

  List<SoupElement> findAll(tag) {
    return new SoupElement(dom.body).findAll(tag);
  }

}