import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/theme_provider.dart';

/// 聊天输入框
class MessageInputWidget extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSend;
  final String hint;
  final bool enable;

  const MessageInputWidget({Key? key, this.onChanged, this.onSend, required this.hint, this.enable = true}) : super(key: key);

  @override
  State<MessageInputWidget> createState() => _MessageInputWidgetState();
}

class _MessageInputWidgetState extends State<MessageInputWidget> {
  bool _showSend = false;
  final _controller = TextEditingController();
  //键盘处理
  final FocusNode _focusNode = FocusNode();

  get _input {
    return Expanded(
        child: TextField(
      onChanged: _onChanged,
      controller: _controller,
      focusNode: _focusNode,
      style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400),
      // 输入框样式
      decoration: InputDecoration(
          // 圆角
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
          filled: true,
          // 输入框样式的大小约束
          constraints: const BoxConstraints(maxHeight: 36),
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.only(left: 10),
          hintStyle: const TextStyle(fontSize: 14),
          hintText: widget.hint),
    ));
  }

  /// 属性可携带参数
  get _sendBtn => (color) {
   return Container(
      margin: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: widget.enable ? color : Colors.blueGrey,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
      child: InkWell(
        onTap: widget.enable ? _onSend : null,
        child: const Text('发送', style: TextStyle(color: Colors.white, fontSize: 12)),
      ),
    );
  };

  @override
  Widget build(BuildContext context) {

    var themeProvider = context.watch<ThemeProvider>();
    var color = themeProvider.themeColor;
    // ios刘海屏，底部有间距
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
      ),
      child: Row(
        children: [_input, if (_showSend) _sendBtn(color)],
      ),
    );
  }

  void _onChanged(String value) {
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
    setState(() {
      _showSend = value.isNotEmpty;
    });
  }

  void _onSend() {
    if (widget.onSend != null) {
      widget.onSend!();
      _controller.clear();
      _focusNode.unfocus();
      setState(() {
        _showSend = false;
      });
    }
  }
}
