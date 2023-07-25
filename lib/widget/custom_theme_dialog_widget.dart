import 'package:flutter/material.dart';

typedef OnColorClickCallback = void Function(MaterialColor color, String colorStr);

class CustomThemeDialogWidget extends StatelessWidget {
  final OnColorClickCallback onColorClickCallback;

  const CustomThemeDialogWidget({super.key, required this.onColorClickCallback});

  @override
  Widget build(BuildContext context) {
    var themes = ['blue', 'red', 'pink', 'purple', 'deepPurple', 'indigo', 'cyan', 'teal', 'green', 'lightGreen', 'lime', 'yellow', 'amber', 'orange', 'deepOrange', 'brown', 'grey', 'blueGrey'];
    return Dialog(
      child: Container(
        padding: const EdgeInsets.only(left: 4, top: 8,right: 4,bottom: 8),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 6.0,
            mainAxisSpacing: 6.0,
          ),
          itemCount: themes.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pop(context);
                _onColorClick(themes[index]);
              },
              child: Container(
                decoration: BoxDecoration(color: getThemeColor(themes[index])),
              ),
            );
          },
        ),
      ),
    );
  }

  MaterialColor getThemeColor(String? theme) {
    MaterialColor? color;
    switch (theme) {
      case 'blue':
        color = Colors.blue;
        break;
      case 'red':
        color = Colors.red;
        break;
      case 'deepPurple':
        color = Colors.deepPurple;
        break;
      case 'indigo':
        color = Colors.indigo;
        break;
      case 'lightBlue':
        color = Colors.lightBlue;
        break;
      case 'cyan':
        color = Colors.cyan;
        break;
      case 'teal':
        color = Colors.teal;
        break;
      case 'purple':
        color = Colors.purple;
        break;
      case 'green':
        color = Colors.green;
        break;
      case 'lightGreen':
        color = Colors.lightGreen;
        break;
      case 'lime':
        color = Colors.lime;
        break;
      case 'yellow':
        color = Colors.yellow;
        break;
      case 'amber':
        color = Colors.amber;
        break;
      case 'orange':
        color = Colors.orange;
        break;
      case 'deepOrange':
        color = Colors.deepOrange;
        break;
      case 'brown':
        color = Colors.brown;
        break;
      case 'grey':
        color = Colors.grey;
        break;
      case 'pink':
        color = Colors.pink;
        break;
      case 'blueGrey':
        color = Colors.blueGrey;
        break;
      default:
        color = Colors.pink;
        break;
    }
    return color;
  }

  _onColorClick(String theme) {
    onColorClickCallback(getThemeColor(theme),theme);
  }
}
