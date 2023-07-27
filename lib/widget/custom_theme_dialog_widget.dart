import 'package:chatgpt_flutter/provider/theme_provider.dart';
import 'package:flutter/material.dart';

// typedef OnColorClickCallback = void Function(MaterialColor color, String colorStr);

class CustomThemeDialogWidget extends StatelessWidget {
  // final OnColorClickCallback onColorClickCallback;
  final ValueChanged<String> onThemeChange;
  const CustomThemeDialogWidget({super.key, required this.onThemeChange});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.only(left: 4, top: 8,right: 4,bottom: 8),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 6.0,
            mainAxisSpacing: 6.0,
          ),
          itemCount: ThemeProvider.themes.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pop(context);
                _onColorClick(ThemeProvider.themes[index]);
              },
              child: Container(
                decoration: BoxDecoration(color: ThemeProvider.getThemeColor(ThemeProvider.themes[index])),
              ),
            );
          },
        ),
      ),
    );
  }


  _onColorClick(String theme) {
    // onColorClickCallback(getThemeColor(theme),theme);
    onThemeChange(theme);
  }
}
