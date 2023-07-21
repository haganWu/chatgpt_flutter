import 'package:chat_message/util/date_format_utils.dart';
import 'package:chatgpt_flutter/models/favorite_model.dart';
import 'package:flutter/material.dart';
import 'package:login_sdk/util/padding_extension.dart';
import 'package:openai_flutter/utils/ai_logger.dart';

import '../util/hi_dialog.dart';

typedef WonderfulCallback = Function(FavoriteModel);

class WonderfulItemWidget extends StatelessWidget {
  final FavoriteModel model;
  final WonderfulCallback onPress;
  final WonderfulCallback onDelete;
  final WonderfulCallback onCopy;
  final WonderfulCallback onShare;
  final WonderfulCallback onMore;

  const WonderfulItemWidget({super.key, required this.model, required this.onPress, required this.onDelete, required this.onCopy, required this.onShare, required this.onMore});

  get _item => Card(
        margin: const EdgeInsets.only(left: 10, top: 4, right: 10, bottom: 4),
        elevation: 10.0,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, top: 6, right: 10, bottom: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.content,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600),
              ),
              12.paddingHeight,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    model.ownerName!,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    DateFormatUtils.format(model.createdAt!, dayOnly: false),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              )
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPress(model);
      },
      onLongPress: () => _showPopMenu(context),
      child: _item,
    );
  }

  _showPopMenu(BuildContext context) {
    AiLogger.log(message: 'showPopupWindow', tag: 'WonderfulItemWidget');
    HiDialog.showPopMenu(
      context,
      offsetX: -50,
      offsetY: -4,
      items: [
        PopupMenuItem(
          child: const Text('复制'),
          onTap: () {
            onCopy(model);
          },
        ),
        PopupMenuItem(
          child: const Text('删除'),
          onTap: () {
            onDelete(model);
          },
        ),
        PopupMenuItem(
          child: const Text('转发'),
          onTap: () {
            onShare(model);
          },
        ),
        PopupMenuItem(
          child: const Text('更多'),
          onTap: () {
            onMore(model);
          },
        ),
      ],
    );
  }
}
