import 'package:flutter/material.dart';

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

  get _input {
    return Expanded(
        child: TextField(
      onChanged: _onChanged,
      controller: _controller,
      style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w400),
      // 输入框样式
      decoration: InputDecoration(
          // 圆角
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
          filled: true,
          // 输入框样式的大小约束
          constraints: const BoxConstraints(maxHeight: 30),
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.only(left: 10),
          hintStyle: const TextStyle(fontSize: 12),
          hintText: widget.hint),
    ));
  }

  get _sendBtn => Container(
        margin: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.only(left: 8,right: 8,top: 4,bottom: 4),
        // 水波纹按钮
        child: InkWell(
          onTap: _onSend,
          child: const Text('发送', style: TextStyle(color: Colors.white, fontSize: 10)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    // ios刘海屏，底部有间距
    var bottom = MediaQuery.of(context).padding.bottom + 4;
    return Container(
      height: 38,
      padding: EdgeInsets.only(left: 12, right: 12, top: 4, bottom: bottom),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
      ),
      child: Row(
        children: [_input, if (_showSend) _sendBtn],
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
      setState(() {
        _showSend = false;
      });
    }
  }
}
