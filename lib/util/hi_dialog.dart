import 'package:flutter/material.dart';

class HiDialog {
  /// 私有构造
  HiDialog._();
  /// 弹窗
  static Future<T?> showPopMenu<T>(BuildContext context, {required List<PopupMenuEntry<T>> items, double offsetX = 0, offsetY = 0}) {
    var x = MediaQuery.of(context).size.width / 2 + offsetX;
    // 根据手指点击位置计算Y轴坐标
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    var y = offset.dy + renderBox.size.height + offsetY;
    // 弹框展示位置
    final RelativeRect position = RelativeRect.fromLTRB(x, y, x, 0);
    return showMenu(context: context, position: position, items: items);
  }

  /// Toast提示
  static showSnackBar(BuildContext context, String message){
    if(!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message),duration: const Duration(milliseconds: 200),));
  }
}
