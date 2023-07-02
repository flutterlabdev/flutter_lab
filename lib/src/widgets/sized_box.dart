import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_provider.dart';
import '../enums.dart';
import '../mixin.dart';

class LabSizedBox extends StatefulWidget {
  const LabSizedBox({
    Key? key,
    this.name = "SizedBox",
    this.height,
    this.width,
    this.child,
  }) : super(key: key);
  final String name;
  final double? height;
  final double? width;
  final Widget? child;

  @override
  State<LabSizedBox> createState() => _LabSizedBoxState();
}

class _LabSizedBoxState extends State<LabSizedBox> with Cmn {
  final type = WidgetType.SizedBox;

  @override
  void initState() {
    super.initState();
    init(type, widget.name);
  }

  @override
  void didUpdateWidget(LabSizedBox oldWidget) {
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

        return SizedBox(
          width: width,
          height: height,
          child: widget.child,
        );
      },
    );
  }
}
