import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_provider.dart';
import '../enums.dart';
import '../mixin.dart';
import '../utils.dart';

class LabAlign extends StatefulWidget {
  const LabAlign({
    Key? key,
    this.name = "Align",
    this.alignment,
    this.heightFactor,
    this.widthFactor,
    this.child,
  }) : super(key: key);
  final String name;
  final AlignmentGeometry? alignment;
  final double? heightFactor;
  final double? widthFactor;
  final Widget? child;

  @override
  State<LabAlign> createState() => _LabAlignState();
}

class _LabAlignState extends State<LabAlign> with Cmn {
  final type = WidgetType.Align;

  @override
  void initState() {
    super.initState();
    init(type, widget.name);
  }

  @override
  void didUpdateWidget(LabAlign oldWidget) {
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

        AlignmentGeometry? alignment;

        if (dataHasPathAndNeString(data, ["alignment", "Alignment"])) {
          final val = data["alignment"]["Alignment"];
          alignment = alignments[val];
        }

        double? widthFactor = data.containsKey("widthFactor")
            ? data["widthFactor"] == null
                ? null
                : double.tryParse(data["widthFactor"])
            : widget.widthFactor;

        double? heightFactor = data.containsKey("heightFactor")
            ? data["heightFactor"] == null
                ? null
                : double.tryParse(data["heightFactor"])
            : widget.heightFactor;

        return Align(
          alignment: alignment ?? widget.alignment ?? Alignment.center,
          widthFactor: widthFactor,
          heightFactor: heightFactor,
          child: widget.child,
        );
      },
    );
  }
}
