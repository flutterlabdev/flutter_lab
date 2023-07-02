import 'constants.dart';
import 'lab.dart';
import 'variables.dart';

void widgetListChanged() {
  if (socket != null) {
    if (connected) {
      sendWidgetDataList();
    }
  }
}

void sendWidgetDataList() {
  socket?.emit(
    "wl",
    [
      {
        "v": buildNum,
        "data": widgetListJson,
      }
    ],
  );
}

//widgets data request
void requestData() {
  socket?.emit(
    "wr",
    [
      {
        "v": buildNum,
      }
    ],
  );
}
