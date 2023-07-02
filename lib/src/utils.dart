// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

import 'enums.dart';

dataHasPath(dynamic data, List<String> keyList) {
  dynamic dataTemp;
  try {
    data as Map;
    dataTemp = {...data};
    for (var key in keyList) {
      if (dataTemp.containsKey(key)) {
        dataTemp = dataTemp[key];
      } else {
        return false;
      }
    }
    return true;
  } catch (e) {
    return false;
  }
}

/// checks data exist in path and value is string - (not empty)
dataHasPathAndNeString(dynamic data, List<String> keyList) {
  dynamic dataTemp;
  try {
    data as Map;
    dataTemp = {...data};
    for (var key in keyList) {
      if (dataTemp.containsKey(key)) {
        dataTemp = dataTemp[key];
      } else {
        return false;
      }
    }

    if (dataTemp is String && dataTemp != "") {
      return true;
    }

    return false;
  } catch (e) {
    return false;
  }
}

/// checks data exist in path and value is Map - (not empty)
dataHasPathAndNeMap(dynamic data, List<String> keyList) {
  dynamic dataTemp;
  try {
    data as Map;
    dataTemp = {...data};
    for (var key in keyList) {
      if (dataTemp.containsKey(key)) {
        dataTemp = dataTemp[key];
      } else {
        return false;
      }
    }

    if (dataTemp is Map && dataTemp.isNotEmpty) {
      return true;
    }

    return false;
  } catch (e) {
    return false;
  }
}

// checks data is double [string] or null
double? dataPathNullOrDouble(dynamic data, List<String> keyList) {
  dynamic dataTemp;
  try {
    data as Map;
    dataTemp = {...data};
    for (var key in keyList) {
      if (dataTemp.containsKey(key)) {
        dataTemp = dataTemp[key];
      } else {
        return null;
      }
    }

    if (dataTemp is String && dataTemp != "") {
      return double.tryParse(dataTemp);
    }

    return null;
  } catch (e) {
    return null;
  }
}

EdgeInsetsGeometry? paddingFromData(data, EdgeInsetsGeometry? padding) {
  if (data.containsKey("padding")) {
    if (data["padding"] == null) {
      return null;
    } else if (dataHasPath(data, ["padding", "EdgeInsets"])) {
      final edgeInsets = data["padding"]["EdgeInsets"];

      if (edgeInsets == "zero") {
        return EdgeInsets.zero;
      } else if (edgeInsets is Map) {
        bool isedg = padding != null && padding is EdgeInsets;

        if (dataHasPathAndNeString(edgeInsets, ["all"])) {
          final double val = double.tryParse(edgeInsets["all"]) ?? 0;
          return EdgeInsets.all(val);
        } else if (dataHasPathAndNeMap(edgeInsets, ["symmetric"])) {
          final symmetric = edgeInsets["symmetric"];
          double? hor = dataPathNullOrDouble(symmetric, ["horizontal"]);
          double? ver = dataPathNullOrDouble(symmetric, ["vertical"]);

          hor ??= isedg && padding.left == padding.right ? padding.left : 0;

          ver ??= isedg && padding.top == padding.bottom ? padding.top : 0;

          return EdgeInsets.symmetric(horizontal: hor, vertical: ver);
        } else if (dataHasPathAndNeMap(edgeInsets, ["only"])) {
          final only = edgeInsets["only"];
          double? left = dataPathNullOrDouble(only, ["left"]);
          double? top = dataPathNullOrDouble(only, ["top"]);
          double? right = dataPathNullOrDouble(only, ["right"]);
          double? bottom = dataPathNullOrDouble(only, ["bottom"]);

          return EdgeInsets.only(
            left: left ?? (isedg ? padding.left : 0),
            top: top ?? (isedg ? padding.top : 0),
            right: right ?? (isedg ? padding.right : 0),
            bottom: bottom ?? (isedg ? padding.bottom : 0),
          );
        }
      }
    } else {
      //if incompatible
      return padding;
    }
  } else {
    return padding;
  }

  return null;
}

BorderRadiusGeometry? borderRadiusFromData(data, BorderRadiusGeometry? original) {
  var originalBr = BorderRadius.zero;

  if (original is BorderRadius) {
    originalBr = original;
  }

  Radius topLeft = originalBr.topLeft;
  Radius topRight = originalBr.topRight;
  Radius bottomLeft = originalBr.bottomLeft;
  Radius bottomRight = originalBr.bottomRight;

  if (dataHasPath(data, ["borderRadius", "BorderRadius"])) {
    final borderRadius = data["borderRadius"]["BorderRadius"];

    if (dataHasPathAndNeString(borderRadius, ["circular"])) {
      return BorderRadius.circular(double.tryParse(borderRadius["circular"]) ?? 0);
    } else if (dataHasPath(borderRadius, ["all", "Radius"])) {
      final all = borderRadius["all"];

      return BorderRadius.all(radiusFromData(all, [topLeft, topRight, bottomLeft, bottomRight]));
    } else if (dataHasPath(borderRadius, ["horizontal"])) {
      final horizontal = borderRadius["horizontal"];
      final left = horizontal["left"];
      final right = horizontal["right"];

      return BorderRadius.horizontal(
        left: radiusFromData(left, [topLeft, bottomLeft]),
        right: radiusFromData(right, [topRight, bottomRight]),
      );
    } else if (dataHasPath(borderRadius, ["vertical"])) {
      final horizontal = borderRadius["vertical"];

      final top = horizontal["top"];
      final bottom = horizontal["bottom"];

      return BorderRadius.vertical(
        top: radiusFromData(top, [topLeft, topRight]),
        bottom: radiusFromData(bottom, [bottomLeft, bottomRight]),
      );
    } else if (dataHasPath(borderRadius, ["only"])) {
      final only = borderRadius["only"];

      final topLeftData = only["topLeft"];
      final topRightData = only["topRight"];
      final bottomLeftData = only["bottomLeft"];
      final bottomRightData = only["bottomRight"];

      return BorderRadius.only(
        topLeft: radiusFromData(topLeftData, [topLeft]),
        topRight: radiusFromData(topRightData, [topRight]),
        bottomLeft: radiusFromData(bottomLeftData, [bottomLeft]),
        bottomRight: radiusFromData(bottomRightData, [bottomRight]),
      );
    }
  }

  return null;
}

bool sameRad(List<Radius> list) {
  return list.every((number) => number.x == list[0].x);
}

///circular or elliptical
Radius radiusFromData(data, List<Radius> refRadiuslar) {
  double? x;
  double? y;

  if (data == null) {
    x ??= sameRad(refRadiuslar) ? refRadiuslar[0].x : 0;
    y ??= sameRad(refRadiuslar) ? refRadiuslar[0].y : 0;
  } else {
    data = data["Radius"];

    if (data == "zero") {
      x = 0;
      y = 0;
    } else if (dataHasPathAndNeString(data, ["circular"])) {
      x = double.tryParse(data["circular"]) ?? 0;
      y = x;
    } else if (dataHasPath(data, ["elliptical"])) {
      final elliptical = data["elliptical"];
      x = dataPathNullOrDouble(elliptical, ["x"]);
      y = dataPathNullOrDouble(elliptical, ["y"]);

      x ??= sameRad(refRadiuslar) ? refRadiuslar[0].x : 0;
      y ??= sameRad(refRadiuslar) ? refRadiuslar[0].y : 0;
    } else {
      x = 0;
      y = 0;
    }
  }

  return Radius.elliptical(x, y);
}

Border? borderFromData(data, BoxBorder? original) {
  final border = data["border"];

  if (border == null) {
    return null;
  }

  Border? originalBorder;

  if (original is Border) {
    originalBorder = original;
  }

  BorderSide? top = originalBorder?.top;
  BorderSide? left = originalBorder?.left;
  BorderSide? right = originalBorder?.right;
  BorderSide? bottom = originalBorder?.bottom;

  if (dataHasPath(border, ["Border", "all"])) {
    final all = border["Border"]["all"];

    final side = borderSideFromData(all, [top, left, right, bottom]);

    return Border.all(
      width: side.width,
      color: side.color,
      strokeAlign: side.strokeAlign,
      style: side.style,
    );
  } else if (dataHasPath(border, ["Border", "symmetric"])) {
    final symmetric = border["Border"]["symmetric"];
    final sideHorz = borderSideFromData(symmetric["horizontal"], [top, bottom]);
    final sideVert = borderSideFromData(symmetric["vertical"], [left, right]);

    return Border.symmetric(
      horizontal: BorderSide(
        width: sideHorz.width,
        color: sideHorz.color,
        strokeAlign: sideHorz.strokeAlign,
        style: sideHorz.style,
      ),
      vertical: BorderSide(
        width: sideVert.width,
        color: sideVert.color,
        strokeAlign: sideVert.strokeAlign,
        style: sideVert.style,
      ),
    );
  } else if (dataHasPath(border, ["Border", "left"]) || dataHasPath(border, ["Border", "top"]) || dataHasPath(border, ["Border", "right"]) || dataHasPath(border, ["Border", "bottom"])) {
    final borderOnly = border["Border"];

    return Border(
      top: borderSideFromData(borderOnly["top"], [top]),
      left: borderSideFromData(borderOnly["left"], [left]),
      right: borderSideFromData(borderOnly["right"], [right]),
      bottom: borderSideFromData(borderOnly["bottom"], [bottom]),
    );
  }

  return null;
}

BorderSide borderSideFromData(data, List<BorderSide?> refOthers) {
  if (data == null) {
    if (sameParamOrNull(refOthers, BorderSideParam.width) == null && sameParamOrNull(refOthers, BorderSideParam.color) == null) {
      return BorderSide.none;
    }
  }

  bool colorDataNo = false;
  bool widthDataNo = false;

  Color? color;
  if (dataHasPathAndNeString(data, ["BorderSide", "color", "Color"])) {
    color = getColorFromHex(data["BorderSide"]["color"]["Color"]);
  } else {
    colorDataNo = true;
    color = sameParamOrNull(refOthers, BorderSideParam.color);
  }

  color ??= const Color(0xFF000000);

  double? width = dataPathNullOrDouble(data, ["BorderSide", "width"]);

  if (width == null) {
    widthDataNo = true;
    width ??= sameParamOrNull(refOthers, BorderSideParam.width);
  }

  width ??= 1;

  BorderStyle? style;
  if (dataHasPathAndNeString(data, ["BorderSide", "style", "BorderStyle"]) && data["BorderSide"]["style"]["BorderStyle"] == "none") {
    style = BorderStyle.none;
  } else {
    if (sameParamOrNull(refOthers, BorderSideParam.style) == BorderStyle.none && colorDataNo && widthDataNo) {
      style = BorderStyle.none;
    }
  }
  style ??= BorderStyle.solid;

  double strokeAlign = dataPathNullOrDouble(data, ["BorderSide", "strokeAlign"]) ?? sameParamOrNull(refOthers, BorderSideParam.strokeAlign) ?? -1;

  return BorderSide(
    width: width,
    color: color,
    strokeAlign: strokeAlign,
    style: style,
  );
}

sameParamOrNull(List<BorderSide?> list, BorderSideParam altParam) {
  if (list.any((element) => element == null)) {
    return null;
  }

  final a = List<BorderSide>.from(list);

  switch (altParam) {
    case BorderSideParam.color:
      return a.every((elem) => elem.color == a[0].color) ? a[0].color : null;
    case BorderSideParam.width:
      return a.every((elem) => elem.width == a[0].width) ? a[0].width : null;
    case BorderSideParam.style:
      return a.every((elem) => elem.style == a[0].style) ? a[0].style : null;
    case BorderSideParam.strokeAlign:
      return a.every((elem) => elem.strokeAlign == a[0].strokeAlign) ? a[0].strokeAlign : null;
  }
}

Color getColorFromHex(String hexColor) {
  hexColor = hexColor.replaceAll("0x", "");

  return Color(int.parse(hexColor, radix: 16));
}

const alignments = {
  "topLeft": Alignment.topLeft,
  "topCenter": Alignment.topCenter,
  "topRight": Alignment.topRight,
  "centerLeft": Alignment.centerLeft,
  "center": Alignment.center,
  "centerRight": Alignment.centerRight,
  "bottomLeft": Alignment.bottomLeft,
  "bottomCenter": Alignment.bottomCenter,
  "bottomRight": Alignment.bottomRight,
};
const alignmentDirectionals = {
  "topStart": AlignmentDirectional.topStart,
  "topCenter": AlignmentDirectional.topCenter,
  "topEnd": AlignmentDirectional.topEnd,
  "centerStart": AlignmentDirectional.centerStart,
  "center": AlignmentDirectional.center,
  "centerEnd": AlignmentDirectional.centerEnd,
  "bottomStart": AlignmentDirectional.bottomStart,
  "bottomCenter": AlignmentDirectional.bottomCenter,
  "bottomEnd": AlignmentDirectional.bottomEnd,
};

const fractionalOffsets = {
  "topLeft": FractionalOffset.topLeft,
  "topCenter": FractionalOffset.topCenter,
  "topRight": FractionalOffset.topRight,
  "centerLeft": FractionalOffset.centerLeft,
  "center": FractionalOffset.center,
  "centerRight": FractionalOffset.centerRight,
  "bottomLeft": FractionalOffset.bottomLeft,
  "bottomCenter": FractionalOffset.bottomCenter,
  "bottomRight": FractionalOffset.bottomRight,
};

const stackFits = {
  "loose": StackFit.loose,
  "expand": StackFit.expand,
  "passthrough": StackFit.passthrough,
};
const clips = {
  "hardEdge": Clip.hardEdge,
  "antiAlias": Clip.antiAlias,
  "antiAliasWithSaveLayer": Clip.antiAliasWithSaveLayer,
  "none": Clip.none,
};

const Map<ShapeType, String> shapeTypes = {
  ShapeType.RoundedRectangleBorder: "RoundedRectangleBorder",
  ShapeType.CircleBorder: "CircleBorder",
  ShapeType.BeveledRectangleBorder: "BeveledRectangleBorder",
  ShapeType.StadiumBorder: "StadiumBorder",
  ShapeType.ContinuousRectangleBorder: "ContinuousRectangleBorder",
};
