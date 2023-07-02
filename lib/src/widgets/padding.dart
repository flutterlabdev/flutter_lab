import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_provider.dart';
import '../enums.dart';
import '../mixin.dart';
import '../utils.dart';

class LabPadding extends StatefulWidget {
  const LabPadding({
    Key? key,
    this.name = "Padding",
    this.padding,
    this.child,
  }) : super(key: key);
  final String name;
  final EdgeInsetsGeometry? padding;
  final Widget? child;

  @override
  State<LabPadding> createState() => _LabPaddingState();
}

class _LabPaddingState extends State<LabPadding> with Cmn {
  final type = WidgetType.Padding;

  @override
  void initState() {
    super.initState();
    init(type, widget.name);
  }

  @override
  void didUpdateWidget(LabPadding oldWidget) {
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

        EdgeInsetsGeometry? padding = paddingFromData(data, widget.padding);

        return Padding(
          padding: padding ?? widget.padding ?? EdgeInsets.zero,
          child: widget.child,
        );
      },
    );
  }
}
