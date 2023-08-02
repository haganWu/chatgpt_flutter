import 'package:chatgpt_flutter/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'hi_dialog.dart';

class HiUtils {
  static void copyMessage(BuildContext context, String message) {
    Clipboard.setData(ClipboardData(text: message));
    if (!context.mounted) return;
    HiDialog.showSnackBar(context, '文本已复制到系统剪切板');
  }

  static String getPoxyByPlatform(BuildContext context) {
    TargetPlatform platform = Theme.of(context).platform;
    String proxy = "";
    switch (platform) {
      case TargetPlatform.android:
        proxy = Constants.keyHiProxyAndroid;
        break;
      case TargetPlatform.iOS:
        proxy = Constants.keyHiProxyIOS;
        break;
      default:
        proxy = "";
    }
    return proxy;
  }
}
