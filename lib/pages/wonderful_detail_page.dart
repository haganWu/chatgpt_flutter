import 'package:chat_message/util/date_format_utils.dart';
import 'package:chatgpt_flutter/models/favorite_model.dart';
import 'package:chatgpt_flutter/util/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openai_flutter/utils/ai_logger.dart';
import 'package:provider/provider.dart';
import '../provider/theme_provider.dart';
import '../util/hi_utils.dart';

class WonderfulDetailPage extends StatelessWidget {
  final FavoriteModel model;

  const WonderfulDetailPage({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    var color = themeProvider.themeColor;
    // 设置状态栏的背景颜色与顶部导航栏背景颜色保持一致
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: color,
    ));
    late double xPos = 0;
    late double yPos = 0;
    return Scaffold(
      appBar: WidgetUtils.getCustomAppBar('详情', subTitle: '来自 ${model.ownerName!}  ${DateFormatUtils.formatYMd(model.createdAt!)}', titleCenter: true),
      // 解决文本内容过长无法全部展示问题
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, top: 10, right: 12, bottom: 12),
          child: GestureDetector(
            onTapDown: (TapDownDetails details) {
              xPos = details.globalPosition.dx;
              yPos = details.globalPosition.dy;
            },
            onLongPress: () => _showCopyPopup(context, xPos, yPos),
            child: Text(model.content),
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
          HiUtils.copyMessage(context, model.content);
        },
      ),
    ]);
  }
}
