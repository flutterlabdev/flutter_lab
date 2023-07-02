// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_provider.dart';
import '../enums.dart';
import '../mixin.dart';
import '../utils.dart';

class LabContainer extends StatefulWidget {
  const LabContainer({
    Key? key,
    this.name = "Container",
    this.alignment,
    this.padding,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.height,
    this.width,
    this.constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.child,
    this.clipBehavior = Clip.none,
  }) : super(key: key);
  final String name;
  final AlignmentGeometry? alignment;
  final EdgeInsets? padding;
  final Color? color;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final double? height;
  final double? width;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Widget? child;
  final Clip clipBehavior;

  @override
  State<LabContainer> createState() => _LabContainerState();
}

class _LabContainerState extends State<LabContainer> with Cmn {
  final type = WidgetType.Container;

  @override
  void initState() {
    super.initState();
    init(type, widget.name);
  }

  @override
  void didUpdateWidget(LabContainer oldWidget) {
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

        if (data.containsKey("alignment")) {
          if (data["alignment"] == null) {
            //nullable
            alignment = null;
          } else if (dataHasPathAndNeString(data, ["alignment", "Alignment"])) {
            final val = data["alignment"]["Alignment"];
            alignment = alignments[val];
          } else {
            // if incompatible
            alignment = widget.alignment;
          }
        } else {
          alignment = widget.alignment;
        }

        EdgeInsetsGeometry? padding = paddingFromData(data, widget.padding);

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

        Decoration? decoration;

        if (data.containsKey("decoration")) {
          final decorationMap = data["decoration"];
          if (decorationMap == null) {
            decoration = null;
          } else {
            if (decorationMap is Map) {
              if (decorationMap.containsKey("BoxDecoration")) {
                if (widget.decoration is BoxDecoration) {
                  decoration = widget.decoration;
                }
                decoration as BoxDecoration?;

                final boxDecorationMap = decorationMap["BoxDecoration"];
                if (boxDecorationMap is Map) {
                  Color? decorationColor;

                  if (boxDecorationMap.containsKey("color")) {
                    if (boxDecorationMap["color"] == null) {
                      decorationColor = null;
                    } else if (dataHasPathAndNeString(boxDecorationMap, ["color", "Color"])) {
                      decorationColor = getColorFromHex(boxDecorationMap["color"]["Color"]);
                    } else {
                      //if incompatible
                      decorationColor = decoration?.color;
                    }
                  } else {
                    decorationColor = decoration?.color;
                  }

                  BoxBorder? border = decoration?.border;
                  if (dataHasPath(boxDecorationMap, ["border"])) {
                    border = borderFromData(boxDecorationMap, decoration?.border);
                  } else {
                    border = decoration?.border;
                  }

                  BorderRadiusGeometry? borderRadius;
                  if (boxDecorationMap.containsKey("borderRadius")) {
                    borderRadius = borderRadiusFromData(boxDecorationMap, decoration?.borderRadius);
                  } else {
                    borderRadius = decoration?.borderRadius;
                  }

                  BoxShape? shape;
                  if (boxDecorationMap.containsKey("shape")) {
                    final shapeMap = boxDecorationMap["shape"];
                    if (dataHasPath(shapeMap, ["BoxShape"])) {
                      shape = shapeMap["BoxShape"] == "circle" ? BoxShape.circle : BoxShape.rectangle;
                    }
                  } else {
                    shape = decoration?.shape;
                  }

                  decoration = BoxDecoration(
                    color: decorationColor,
                    border: border,
                    borderRadius: borderRadius,
                    shape: shape ?? BoxShape.rectangle,
                  );
                }
              } else if (decorationMap.containsKey("ShapeDecoration")) {
                final shapeDecorationMap = decorationMap["ShapeDecoration"];
                if (widget.decoration is ShapeDecoration) {
                  decoration = widget.decoration;
                }
                decoration as ShapeDecoration?;

                Color? decorationColor;

                if (shapeDecorationMap.containsKey("color")) {
                  if (shapeDecorationMap["color"] == null) {
                    decorationColor = null;
                  } else if (dataHasPathAndNeString(shapeDecorationMap, ["color", "Color"])) {
                    decorationColor = getColorFromHex(shapeDecorationMap["color"]["Color"]);
                  } else {
                    //if incompatible
                    decorationColor = decoration?.color;
                  }
                } else {
                  decorationColor = decoration?.color;
                }

                ShapeBorder? shape = decoration?.shape;

                if (dataHasPath(shapeDecorationMap, ["shape"])) {
                  final shapeMap = shapeDecorationMap["shape"];

                  ShapeType? shapeType;
                  String geometry = "";
                  shapeTypes.forEach((key, value) {
                    if (dataHasPath(shapeMap, [value])) {
                      shapeType = key;
                      geometry = value;
                    }
                  });

                  if (shapeType != null) {
                    final map = shapeMap[geometry];

                    BorderSide side = BorderSide.none;
                    BorderRadiusGeometry borderRadius = BorderRadius.zero;

                    if (dataHasPath(map, ["side"])) {
                      side = borderSideFromData(map["side"], [BorderSide.none]);
                    }

                    if ([ShapeType.RoundedRectangleBorder, ShapeType.BeveledRectangleBorder, ShapeType.ContinuousRectangleBorder].contains(shapeType)) {
                      if (dataHasPath(map, ["borderRadius"])) {
                        borderRadius = borderRadiusFromData(map, borderRadius) ?? borderRadius;
                      }
                    }

                    switch (shapeType) {
                      case ShapeType.RoundedRectangleBorder:
                        shape = RoundedRectangleBorder(
                          side: side,
                          borderRadius: borderRadius,
                        );
                        break;
                      case ShapeType.CircleBorder:
                        double eccentricity = map.containsKey("eccentricity")
                            ? map["eccentricity"] == null
                                ? 0
                                : double.tryParse(map["eccentricity"] ?? "0") ?? 0
                            : 0;

                        shape = CircleBorder(
                          side: side,
                          eccentricity: eccentricity,
                        );
                        break;
                      case ShapeType.BeveledRectangleBorder:
                        shape = BeveledRectangleBorder(
                          side: side,
                          borderRadius: borderRadius,
                        );
                        break;
                      case ShapeType.StadiumBorder:
                        shape = StadiumBorder(
                          side: side,
                        );
                        break;
                      case ShapeType.ContinuousRectangleBorder:
                        shape = ContinuousRectangleBorder(
                          side: side,
                          borderRadius: borderRadius,
                        );
                        break;
                      default:
                    }
                  }
                }

                decoration = ShapeDecoration(
                  color: decorationColor,
                  shape: shape ?? const RoundedRectangleBorder(),
                );
              }
            }
          }
        } else {
          decoration = widget.decoration;
        }

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

        return Container(
          alignment: alignment,
          padding: padding,
          color: color,
          decoration: decoration,
          foregroundDecoration: widget.foregroundDecoration,
          width: width,
          height: height,
          constraints: widget.constraints,
          margin: widget.margin,
          transform: widget.transform,
          transformAlignment: widget.transformAlignment,
          clipBehavior: widget.clipBehavior,
          child: widget.child,
        );
      },
    );
  }
}
