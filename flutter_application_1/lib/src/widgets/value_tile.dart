import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';

/// General utility widget used to render a cell divided into three rows
/// First row displays [label]
/// second row displays [iconData]
/// third row displays [value]
class ValueTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData? iconData;

  // 改為 const 构造函数，並添加 key 參數
  const ValueTile({
    Key? key,
    required this.label,
    required this.value,
    this.iconData, // iconData 是可選參數
  }) : super(key: key); // 呼叫父類別的 constructor 並傳遞 key

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = AppStateContainer.of(context).theme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          this.label,
          style: TextStyle(
            color: AppStateContainer.of(context)
                .theme
                .colorScheme
                .secondary
                .withAlpha(150),
          ),
        ),
        SizedBox(height: 5),
        if (iconData != null)
          Icon(
            iconData,
            color: appTheme.colorScheme.secondary,
            size: 20,
          ),
        SizedBox(height: 10),
        Text(
          this.value,
          style: TextStyle(color: appTheme.colorScheme.secondary),
        ),
      ],
    );
  }
}
