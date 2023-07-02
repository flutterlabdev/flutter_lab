import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_provider.dart';
import '../enums.dart';
import '../mixin.dart';

class LabOpacity extends StatefulWidget {
  const LabOpacity({
    Key? key,
    this.name = "Opacity",
    this.opacity,
    this.alwaysIncludeSemantics = false,
    this.child,
  }) : super(key: key);
  final String name;
  final double? opacity;
  final bool alwaysIncludeSemantics;
  final Widget? child;

  @override
  State<LabOpacity> createState() => _LabOpacityState();
}

class _LabOpacityState extends State<LabOpacity> with Cmn {
  final type = WidgetType.Opacity;

  @override
  void initState() {
    super.initState();
    init(type, widget.name);
  }

  @override
  void didUpdateWidget(LabOpacity oldWidget) {
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

        double opacity = (data.containsKey("opacity") ? double.tryParse(data["opacity"]) : null) ?? widget.opacity ?? 1;

        return Opacity(
          opacity: opacity,
          alwaysIncludeSemantics: widget.alwaysIncludeSemantics,
          child: widget.child,
        );
      },
    );
  }
}
