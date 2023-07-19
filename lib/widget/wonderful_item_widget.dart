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

  const WonderfulItemWidget({super.key, required this.model, required this.onPress, required this.onDelete});

  get _item => Container(
        margin: const EdgeInsets.only(left: 10, top: 2, right: 10, bottom: 4),
        padding: const EdgeInsets.only(left: 10, top: 4, right: 10, bottom: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.content!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600),
            ),
            10.paddingHeight,
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
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onPress != null) {
          onPress!(model);
        }
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
          child: const Text('删除'),
          onTap: () {
            if (onDelete != null) {
              onDelete!(model);
            }
          },
        ),
      ],
    );
  }
}
