import 'model.dart';

bool connected = false;

List<LabWid> widgetList = [];

List<Map> get widgetListJson {
  List<Map> data = [];
  for (var element in widgetList) {
    data.add({"type": element.type.name, "name": element.name, "id": element.id});
  }
  return data;
}
