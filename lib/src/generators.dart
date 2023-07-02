import 'dart:math';

import 'variables.dart';

String get generateId {
  String? val;
  while (val == null || widgetList.any((element) => element.id == val)) {
    val = generateRandomId;
  }
  return val;
}

String get generateRandomId {
  const length = 8;
  final rand = Random();

  final numberPart = List.generate(length, (_) => rand.nextInt(10));

  final charPart = List.generate(length, (_) => rand.nextInt(26) + 97).map((charCode) => String.fromCharCode(charCode));

  var lastList = [...numberPart, ...charPart];
  lastList.shuffle();

  final result = lastList.join().substring(0, length);

  return result;
}
