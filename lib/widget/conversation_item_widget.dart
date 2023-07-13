import 'package:chat_message/util/date_format_utils.dart';
import 'package:chatgpt_flutter/models/conversation_model.dart';
import 'package:chatgpt_flutter/util/hi_dialog.dart';
import 'package:flutter/material.dart';
import 'package:login_sdk/util/padding_extension.dart';

//定义带有ConversationModel参数的回调
typedef ConversationCallback = Function(ConversationModel model);
typedef ConversationStickCallback = Function({required ConversationModel model, required bool isStick});

class ConversationItemWidget extends StatelessWidget {
  final ConversationModel model;
  final ConversationCallback? onPress;
  final ConversationCallback? onDelete;
  final ConversationStickCallback? onStick;
  final bool showDivider;

  const ConversationItemWidget({
    super.key,
    required this.model,
    this.onPress,
    this.onDelete,
    this.onStick,
    required this.showDivider,
  });

  get _item => Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        color: _itemBackgroundColor,
        height: 60,
        child: Row(
          children: [_icon, 10.paddingWidth, rightLayout],
        ),
      );

  get _itemBackgroundColor => model.stickTime > 0 ? Colors.grey.withOpacity(0.2) : Colors.transparent;

  get _icon => ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(6)),
      child: Image.network(
        model.icon,
        height: 44,
        width: 44,
      ));

  get rightLayout => Expanded(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              5.paddingHeight,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      model.title ?? "",
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  2.paddingWidth,
                  Text(DateFormatUtils.format(model.updateAt ?? 0, dayOnly: false), style: const TextStyle(fontSize: 12, color: Colors.grey))
                ],
              ),
              2.paddingHeight,
              Row(
                children: [
                  Text('[${model.messageCount}条对话]', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  2.paddingWidth,
                  Expanded(
                    child: Text(
                      '${model.lastMessage}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ],
          ),
          if (showDivider) Divider(height: 1, color: Colors.grey.withOpacity(0.6)),
        ],
      ));

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
    var isStick = model.stickTime > 0 ? true : false;
    var showStick = isStick ? '取消置顶' : '置顶';
    HiDialog.showPopMenu(
      context,
      offsetX: -50,
      items: [
        PopupMenuItem(
          child: Text(showStick),
          onTap: () {
            if (onStick != null) {
              onStick!(model: model, isStick: !isStick);
            }
          },
        ),
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
