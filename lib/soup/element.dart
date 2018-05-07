import "package:html/dom.dart";

import "./exceptions.dart";

class SoupElement {
  Element htmlElement;
  SoupElement(this.htmlElement);

  List<SoupElement> findAll(tag){
    final result = new List<SoupElement>();
    htmlElement.children.forEach((child) {
      final soupChild = new SoupElement(child);
      if (child.localName == tag) {
        result.add(soupChild);
      } else {
        result.addAll(soupChild.findAll(tag));
      }
    });
    return result;
  }

  SoupElement findFirst(tag) {
    for (final child in htmlElement.children) {
      if (child.localName == tag) {
        return new SoupElement(child);
      }
    }
    throw new SoupNotFound("Element not found");
  }

  String getAttribute(attribute) {
    return htmlElement.attributes[attribute];
  }

  String get text => htmlElement.text;
}