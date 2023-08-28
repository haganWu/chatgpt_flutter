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
  static showSnackBar(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 200),
    ));
  }

  /// 设置代理弹框
  static Future<List> showProxySettingDialog(BuildContext context, {String? proxyText, GestureTapCallback? onTap}) async {
    var isSave = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Row(
            children: [
              const Text('设置代理', style: TextStyle(fontSize: 14)),
              InkWell(
                onTap: onTap,
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(Icons.question_mark_rounded, color: Colors.grey, size: 18),
                ),
              )
            ],
          ),
          titlePadding: const EdgeInsets.all(8),
          titleTextStyle: const TextStyle(color: Colors.black87, fontSize: 16),
          content: TextField(
            controller: TextEditingController(text: proxyText),
            onChanged: (text) => proxyText = text,
          ),
          contentPadding: const EdgeInsets.all(8),
          contentTextStyle: const TextStyle(color: Colors.black54, fontSize: 14),
          actions: [
            TextButton(
                onPressed: () {
                  // 关闭 返回false
                  Navigator.of(context).pop(false);
                },
                child: const Text('取消')),
            TextButton(
                onPressed: () {
                  // 保存 返回ture
                  Navigator.of(context).pop(true);
                },
                child: const Text('保存')),
          ],
        );
      },
    );
    proxyText = proxyText == null ? proxyText : proxyText!.trim();
    return [isSave, proxyText];
  }
}
