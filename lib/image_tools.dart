import 'package:flutter/material.dart';
import 'package:validator/validator.dart';
import 'dart:convert' show Base64Decoder;

ImageProvider getImageProvider(String url) {
  ImageProvider image;
  if (isURL(url)) {
    image = new NetworkImage(url);
  } else if (url.startsWith("data:")) {
    const encodingMark = ";base64,";
    final encodingStart = url.indexOf(encodingMark);
    if (encodingStart > 0) {
      final data = url.substring(encodingStart + encodingMark.length);
      final decoder = new Base64Decoder();
      final imageData = decoder.convert(data);
      image = new MemoryImage(imageData);
    }
  }
  if (image == null) {
    image = new ExactAssetImage("images/sousmarin.png");
  }
  return image;
}
