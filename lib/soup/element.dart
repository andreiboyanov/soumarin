import "package:html/dom.dart";

import "./exceptions.dart";

class SoupElement {
  Element htmlElement;

  SoupElement(this.htmlElement);

  List<SoupElement> findAll(String tag,
      {Map<String, String> attributes, int limit}) {
    final result = new List<SoupElement>();
    for (final child in htmlElement.children) {
      if (limit != null && result.length >= limit) {
        break;
      }
      final soupChild = new SoupElement(child);
      bool match = true;
      if (tag == null || child.localName == tag) {
        if (attributes != null) {
          attributes.forEach((name, value) {
            if (attributeValueContains(child, name, value) == false) {
              match = false;
              return;
            }
          });
        }
      } else {
        match = false;
      }
      if (match) {
        result.add(soupChild);
      } else {
        result.addAll(soupChild.findAll(
          tag,
          attributes: attributes,
          limit: limit == null ? null : limit - result.length,
        ));
      }
    }
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

  SoupElement find({id}) {
    for (final child in htmlElement.children) {
      var soupChild = new SoupElement(child);
      if (child.id == id) {
        return soupChild;
      } else {
        soupChild = soupChild.find(id: id);
        if (soupChild != null) {
          return soupChild;
        }
      }
    }
    return null;
  }

  String getAttribute(attribute) {
    return htmlElement.attributes[attribute];
  }

  String get text => htmlElement.text;

  String get tag => htmlElement.localName;

  bool attributeValueContains(
      Element html, String attributeName, String attributeValue) {
    if (attributeValue == null) {
      return true;
    }
    if (!html.attributes.containsKey(attributeName)) {
      return false;
    }
    if (html.attributes[attributeName].contains(attributeValue)) {
      return true;
    }
    return false;
  }
}
