import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data_provider.dart';
import 'emits.dart';
import 'enums.dart';
import 'generators.dart';
import 'model.dart';
import 'variables.dart';

mixin Cmn<T extends StatefulWidget> on State<T> {
  late String id;

  late String typeAndName;

  late String refreshId;

  void init(WidgetType type, String name) {
    try {
      context.read<DataProvider>();
    } catch (e) {
      throw Exception('''


to use FlutterLab widgets wrap MyApp() with FlutterLab widget

runApp(
  FlutterLab(
    child: MyApp(),
  ),
);


''');
    }

    id = generateId;
    widgetList.add(LabWid(id: id, name: name, type: type));
    typeAndName = "${type.name}-$name";
    refreshId = "$typeAndName-$id";
    context.read<DataProvider>().add(refreshId);
    widgetListChanged();
  }

  void didUpdate(WidgetType type, String name) {
    widgetList.where((element) => element.id == id).forEach((element) {
      element.name = name;
    });

    typeAndName = "${type.name}-$name";
    refreshId = "$typeAndName-$id";
    context.read<DataProvider>().add(refreshId);
    widgetListChanged();
  }

  void onDispose() {
    widgetList.removeWhere((element) => element.id == id);
    widgetListChanged();
  }
}
