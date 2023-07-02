import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_provider.dart';
import '../enums.dart';
import '../mixin.dart';
import '../utils.dart';

class LabStack extends StatefulWidget {
  const LabStack({
    Key? key,
    this.name = "Stack",
    this.alignment,
    this.textDirection,
    this.fit,
    this.clipBehavior,
    this.children = const <Widget>[],
  }) : super(key: key);
  final String name;
  final AlignmentGeometry? alignment;
  final TextDirection? textDirection;
  final StackFit? fit;
  final Clip? clipBehavior;
  final List<Widget> children;

  @override
  State<LabStack> createState() => _LabStackState();
}

class _LabStackState extends State<LabStack> with Cmn {
  final type = WidgetType.Stack;

  @override
  void initState() {
    super.initState();
    init(type, widget.name);
  }

  @override
  void didUpdateWidget(LabStack oldWidget) {
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

        AlignmentGeometry? alignment = widget.alignment;

        if (dataHasPathAndNeString(data, ["alignment", "AlignmentDirectional"])) {
          final val = data["alignment"]["AlignmentDirectional"];
          alignment = alignmentDirectionals[val] ?? alignment;
        }

        //nullable
        TextDirection? textDirection = widget.textDirection;

        if (dataHasPathAndNeString(data, ["textDirection", "TextDirection"])) {
          final val = data["textDirection"]["TextDirection"];
          textDirection = val == null
              ? null
              : val == "ltr"
                  ? TextDirection.ltr
                  : val == "rtl"
                      ? TextDirection.rtl
                      : textDirection;
        }

        StackFit? fit = widget.fit;

        if (dataHasPathAndNeString(data, ["fit", "StackFit"])) {
          final val = data["fit"]["StackFit"];
          fit = stackFits[val] ?? fit;
        }

        Clip? clipBehavior = widget.clipBehavior;

        if (dataHasPathAndNeString(data, ["clipBehavior", "Clip"])) {
          final val = data["clipBehavior"]["Clip"];
          clipBehavior = clips[val] ?? clipBehavior;
        }

        return Stack(
          alignment: alignment ?? AlignmentDirectional.topStart,
          textDirection: textDirection,
          fit: fit ?? StackFit.loose,
          clipBehavior: clipBehavior ?? Clip.hardEdge,
          children: widget.children,
        );
      },
    );
  }
}
