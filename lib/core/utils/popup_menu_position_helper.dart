import 'package:flutter/widgets.dart';

class PopupMenuPositionHelper {
  static RelativeRect getPopupPosition(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    return RelativeRect.fromLTRB(
      offset.dx + renderBox.size.width,
      offset.dy,
      offset.dx,
      offset.dy + renderBox.size.height,
    );
  }
}
