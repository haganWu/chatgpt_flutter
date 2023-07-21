import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'hi_dialog.dart';

class HiUtils {
  static void copyMessage(BuildContext context, String message) {
    Clipboard.setData(ClipboardData(text: message));
    if (!context.mounted) return;
    HiDialog.showSnackBar(context, '文本已复制到系统剪切板');
  }
}
