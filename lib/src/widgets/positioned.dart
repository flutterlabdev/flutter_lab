import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_provider.dart';
import '../enums.dart';
import '../mixin.dart';

class LabPositioned extends StatefulWidget {
  const LabPositioned({
    Key? key,
    this.name = "Positioned",
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.height,
    this.width,
    required this.child,
  }) : super(key: key);
  final String name;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final double? height;
  final double? width;
  final Widget child;

  @override
  State<LabPositioned> createState() => _LabPositionedState();
}

class _LabPositionedState extends State<LabPositioned> with Cmn {
  final type = WidgetType.Positioned;

  @override
  void initState() {
    super.initState();
    init(type, widget.name);
  }

  @override
  void didUpdateWidget(LabPositioned oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.name != widget.name) {
      didUpdate(type, widget.name);
    }
  }

  @override
  void dispose() {
    super.dispose();
    onDispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Provider.of<DataProvider>(context, listen: true).notifiers[refreshId]!,
      builder: (context, value, child) {
        Map data = Provider.of<DataProvider>(context, listen: true).widgetData(typeAndName) ?? {};

        double? left = data.containsKey("left")
            ? data["left"] == null
                ? null
                : double.tryParse(data["left"])
            : widget.left;

        double? top = data.containsKey("top")
            ? data["top"] == null
                ? null
                : double.tryParse(data["top"])
            : widget.top;

        double? right = data.containsKey("right")
            ? data["right"] == null
                ? null
                : double.tryParse(data["right"])
            : widget.right;

        double? bottom = data.containsKey("bottom")
            ? data["bottom"] == null
                ? null
                : double.tryParse(data["bottom"])
            : widget.bottom;

        double? width = data.containsKey("width")
            ? data["width"] == null
                ? null
                : double.tryParse(data["width"])
            : widget.width;

        double? height = data.containsKey("height")
            ? data["height"] == null
                ? null
                : double.tryParse(data["height"])
            : widget.height;

        return Positioned(
          left: left,
          top: top,
          right: right,
          bottom: bottom,
          width: width,
          height: height,
          child: widget.child,
        );
      },
    );
  }
}
