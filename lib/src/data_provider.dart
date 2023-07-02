// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'emits.dart';

class DataProvider with ChangeNotifier {
  String activeProjectId = "";

  Map<String, ValueNotifier> notifiers = {};

  void add(id) {
    notifiers[id] = ValueNotifier(null);
  }

  void remove(id) {
    notifiers.remove(id);
  }

  Map raw = {};

  widgetData(String id) {
    return raw[activeProjectId]?[id]?["data"] ?? {};
  }

  void clearData() {
    if (raw.isNotEmpty) {
      raw.clear();
      notifyListeners();
    }
  }

  void dataUpdate(data) {
    var id = "${data["type"]}-${data["name"]}";
    activeProjectId = data["projectId"];

    if (!raw.containsKey(activeProjectId)) {
      raw[activeProjectId] = {};
    }

    raw[activeProjectId][id] = {"id": data["id"], "data": data["data"]};

    notifiers.entries.where((element) => element.key.startsWith(id + "-")).forEach((element) {
      element.value.notifyListeners();
    });
  }

  void projectIdRefresh(data) {
    activeProjectId = data["id"];
    notifyListeners();

    if (raw[activeProjectId] == null) {
      requestData();
    }
  }
}
