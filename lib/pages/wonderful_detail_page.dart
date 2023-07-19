import 'package:chatgpt_flutter/models/favorite_model.dart';
import 'package:chatgpt_flutter/util/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:openai_flutter/utils/ai_logger.dart';

class WonderfulDetailPage extends StatelessWidget {
  final FavoriteModel model;

  const WonderfulDetailPage({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    late double xPos = 0;
    late double yPos = 0;

    return Scaffold(
      appBar: WidgetUtils.getCustomAppBar('详情', subTitle: '来自${model.ownerName!}', titleCenter: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, top: 10, right: 12, bottom: 12),
          child: GestureDetector(
            onTapDown: (TapDownDetails details) {
              xPos = details.globalPosition.dx;
              yPos = details.globalPosition.dy;
            },
            onLongPress: () => _showCopyPopup(context, xPos, yPos),
            child: Text(model.content!),
          ),
        ),
      ),
    );
  }

  _showCopyPopup(BuildContext context, double xPos, double yPos) {
    AiLogger.log(message: '_showCopyPopup', tag: 'WonderfulDetailPage');
    // 弹框展示位置
    final RelativeRect position = RelativeRect.fromLTRB(xPos, yPos, xPos, 0);
    showMenu(context: context, position: position, items: [
      PopupMenuItem(
        child: const Text('复制'),
        onTap: () {
          Clipboard.setData(ClipboardData(text: model.content!));
          AiLogger.log(message: '复制！！', tag: 'DialogClick');
          Fluttertoast.showToast(
            msg: '文本已复制到系统剪切板',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        },
      ),
    ]);
  }
}
