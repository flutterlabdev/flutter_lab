import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_provider.dart';
import '../enums.dart';
import '../mixin.dart';
import '../utils.dart';

class LabIcon extends StatefulWidget {
  const LabIcon(
    this.icon, {
    Key? key,
    this.name = "Icon",
    this.size,
    this.fill,
    this.weight,
    this.grade,
    this.opticalSize,
    this.color,
    this.shadows,
    this.semanticLabel,
    this.textDirection,
  }) : super(key: key);
  final String name;
  final IconData? icon;
  final double? size;
  final double? fill;
  final double? weight;
  final double? grade;
  final double? opticalSize;
  final Color? color;
  final TextDirection? textDirection;
  final List<Shadow>? shadows;
  final String? semanticLabel;
  @override
  State<LabIcon> createState() => _LabIconState();
}

class _LabIconState extends State<LabIcon> with Cmn {
  final type = WidgetType.Icon;

  @override
  void initState() {
    super.initState();
    init(type, widget.name);
  }

  @override
  void didUpdateWidget(LabIcon oldWidget) {
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

        IconData? icon;

        if (dataHasPathAndNeMap(data, ["icon"])) {
          var dt = data["icon"];

          icon = IconData(
            int.parse(dt["codePoint"].substring(2), radix: 16),
            matchTextDirection: dt["matchTextDirection"],
            fontFamily: dt["fontFamily"],
            fontPackage: dt["fontPackage"],
          );
        } else {
          icon = widget.icon;
        }

        Color? color;

        if (data.containsKey("color")) {
          if (data["color"] == null) {
            color = null;
          } else if (dataHasPathAndNeString(data, ["color", "Color"])) {
            color = getColorFromHex(data["color"]["Color"]);
          } else {
            color = widget.color;
          }
        } else {
          color = widget.color;
        }

        double? size = data.containsKey("size")
            ? data["size"] == null
                ? null
                : double.tryParse(data["size"])
            : widget.size;

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

        if (icon == null) {
          return SizedBox.shrink();
        }

        return Icon(
          icon,
          size: size,
          fill: widget.fill,
          weight: widget.weight,
          grade: widget.grade,
          opticalSize: widget.opticalSize,
          color: color,
          shadows: widget.shadows,
          semanticLabel: widget.semanticLabel,
          textDirection: textDirection,
        );
      },
    );
  }
}
