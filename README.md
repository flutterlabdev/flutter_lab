Flutter package for FlutterLab, a UI design tool


<img src="https://raw.githubusercontent.com/flutterlabdev/flutter_lab/master/resources/loop.gif" style="max-width:80%;width:500px"/>


<a href="http://www.youtube.com/watch?v=h-2Txww87Cw"  target="_blank">Watch on Youtube</a>

## Install FlutterLab (for windows)

Install FlutterLab => 
<a href="https://github.com/flutterlabdev/flutter_lab/releases/download/static/FlutterLabSetup.exe" target="_blank">FlutterLabSetup.exe</a> (Download for windows)

## Usage


```dart

import 'package:flutter_lab/flutter_lab.dart';

```


Wrap MyApp() with FlutterLab widget, to connect FlutterLab App


```dart

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  // ...

  runApp(
    const FlutterLab(
      child: MyApp(),
    ),
  );
}

```


Change Container widget to LabContainer (add Lab prefix) to manage parameters from FlutterLab App

```dart
LabContainer(
  // Container parameters
  width:300,
  height:200,
);

LabOpacity(
  opacity: 0.5,
  chid: Text("new"),
);

LabRow(
  children: [
    LabPadding(
      padding: EdgeInsets.all(8),
      child: Text("design"),
    ),
    Stack(
      children:[
        LabPositioned(
          child:Icon(Icons.add),
        ),
      ],
    ),
  ],
);

```

These widgets can be used

- Container -> LabContainer
- Padding -> LabPadding
- Row -> LabRow
- Column -> LabColumn
- Stack -> LabStack
- Align -> LabAlign
- Positioned -> LabPositioned
- SizedBox -> LabSizedBox
- Opacity -> LabOpacity




## Detail

In order to control specific widgets, the "name" parameter can be used.
"name" value and FlutterLab App widget name must be the same.

```dart
LabContainer(
  name: "background", // Rename the Container widget to "background" in FlutterLab App
  width: 300,
  height: 200,
  child: Row(
    children:[
      LabContainer(
        name: "box", // Rename the Container widget to "box" in FlutterLab App
        color: Colors.blue,
      ),
      LabContainer(
        name: "box",
        color: Colors.blue,
      ),
    ],
  ),
);

LabOpacity(
  name: "Opacity 2", 
  child: ...
);

LabPadding(
  name: "box padding",
  padding: EdgeInsets.all(8),
  child: ...
);

```

## Connection
If needed, these parameters can be added to FlutterLab.

Hot restart is required after changing the parameters.

```dart
  runApp(
    const FlutterLab(
      url: "http://192.168.1.200", //default "http://localhost"
      port: 3010, //default 3000
      child: MyApp(),
    ),
  );


```


This package uses socket_io_client.
If required, the connection solutions here can be used.

https://pub.dev/packages/socket_io_client


