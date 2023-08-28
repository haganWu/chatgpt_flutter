import 'package:chatgpt_flutter/provider/theme_provider.dart';
import 'package:flutter/material.dart';

// typedef OnColorClickCallback = void Function(MaterialColor color, String colorStr);
const _colorShades = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900];

class CustomThemeDialogWidget extends StatelessWidget {
  // final OnColorClickCallback onColorClickCallback;
  final ValueChanged<String> onThemeChange;

  const CustomThemeDialogWidget({super.key, required this.onThemeChange});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 566,
        padding: const EdgeInsets.only(left: 4, top: 8, right: 4, bottom: 8),
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ThemeProvider.getThemeColor(ThemeProvider.themes[index]),
                    //     gradient: LinearGradient(
                    //   // colors: _colorShades.reversed.map((e) => ThemeProvider.getThemeColor(ThemeProvider.themes[index])[e]!).toList(),
                    //   begin: Alignment.centerLeft,
                    //   end: Alignment.centerRight,
                    // )
                  ),
                  child: Text(
                    ThemeProvider.themes[index],
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
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
