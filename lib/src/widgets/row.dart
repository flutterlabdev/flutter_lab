import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_provider.dart';
import '../enums.dart';
import '../mixin.dart';
import '../utils.dart';

class LabRow extends StatefulWidget {
  const LabRow({
    Key? key,
    this.name = "Row",
    this.mainAxisAlignment,
    this.mainAxisSize,
    this.crossAxisAlignment,
    this.textDirection,
    this.textBaseline,
    this.verticalDirection,
    this.children = const <Widget>[],
  }) : super(key: key);
  final String name;
  final MainAxisAlignment? mainAxisAlignment;
  final MainAxisSize? mainAxisSize;
  final CrossAxisAlignment? crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection? verticalDirection;
  final TextBaseline? textBaseline;
  final List<Widget> children;

  @override
  State<LabRow> createState() => _LabRowState();
}

class _LabRowState extends State<LabRow> with Cmn {
  final type = WidgetType.Row;

  @override
  void initState() {
    super.initState();
    init(type, widget.name);
  }

  @override
  void didUpdateWidget(LabRow oldWidget) {
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

        MainAxisAlignment mainAxisAlignment = widget.mainAxisAlignment ?? MainAxisAlignment.start;

        if (dataHasPathAndNeString(data, ["mainAxisAlignment", "MainAxisAlignment"])) {
          final val = data["mainAxisAlignment"]["MainAxisAlignment"];
          mainAxisAlignment = MainAxisAlignment.values.firstWhere((element) => element.name == val, orElse: () => mainAxisAlignment);
        }

        MainAxisSize mainAxisSize = widget.mainAxisSize ?? MainAxisSize.max;

        if (dataHasPathAndNeString(data, ["mainAxisSize", "MainAxisSize"])) {
          final val = data["mainAxisSize"]["MainAxisSize"];
          mainAxisSize = val == "max" ? MainAxisSize.max : MainAxisSize.min;
        }

        CrossAxisAlignment crossAxisAlignment = widget.crossAxisAlignment ?? CrossAxisAlignment.center;

        if (dataHasPathAndNeString(data, ["crossAxisAlignment", "CrossAxisAlignment"])) {
          final val = data["crossAxisAlignment"]["CrossAxisAlignment"];
          crossAxisAlignment = CrossAxisAlignment.values.firstWhere((element) => element.name == val, orElse: () => crossAxisAlignment);
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

        VerticalDirection verticalDirection = widget.verticalDirection ?? VerticalDirection.down;

        if (dataHasPathAndNeString(data, ["verticalDirection", "VerticalDirection"])) {
          final val = data["verticalDirection"]["VerticalDirection"];
          verticalDirection = val == "down" ? VerticalDirection.down : VerticalDirection.up;
        }

        //nullable
        TextBaseline? textBaseline = widget.textBaseline;

        if (dataHasPathAndNeString(data, ["textBaseline", "TextBaseline"])) {
          final val = data["textBaseline"]["TextBaseline"];
          textBaseline = val == null
              ? null
              : val == "alphabetic"
                  ? TextBaseline.alphabetic
                  : val == "ideographic"
                      ? TextBaseline.ideographic
                      : textBaseline;
        }

        return Row(
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
          textDirection: textDirection,
          verticalDirection: verticalDirection,
          textBaseline: textBaseline,
          children: widget.children,
        );
      },
    );
  }
}
