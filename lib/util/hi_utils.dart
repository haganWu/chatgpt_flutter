import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'hi_constants.dart';
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
        proxy = HiConstants.keyHiProxyAndroid;
        break;
      case TargetPlatform.iOS:
        proxy = HiConstants.keyHiProxyIOS;
        break;
      default:
        proxy = "";
    }
    return proxy;
  }
  /// 打开H5页面
  static void openH5(String url) async {
    Uri uri = Uri.parse(url);
    if(!await launchUrl(uri, mode: LaunchMode.externalApplication)){
      throw '打开失败';
    }
  }
}
