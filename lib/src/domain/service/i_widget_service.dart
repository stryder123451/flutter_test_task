import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test_task/src/domain/interface/i_widget.dart';

class WidgetService implements IWidget {
  /// Отступы для элемента внутри ряда
  var rowPadding = 5.0;

  /// Минимальная ширина среднего элемента
  var middleWidgetMinimalWidth = 10.0;

  /// Коэффициент заполнения
  var flexCoefficient = 10;

  @override
  Widget generateResizableRow(
      double cardWidth, Widget textWidget, Widget dotWidget, bool isChecked) {
    return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        width: cardWidth,
        child: IntrinsicHeight(
            child: Padding(
                padding: EdgeInsets.all(rowPadding),
                child: Row(children: [
                  textWidget,
                  const VerticalDivider(
                    color: Colors.black,
                  ),
                  dotWidget,
                  const VerticalDivider(
                    color: Colors.black,
                  ),
                  Checkbox(
                    checkColor: Colors.white,
                    value: isChecked,
                    onChanged: (bool? value) {},
                  )
                ]))));
  }

  @override
  Widget generateShrinkableTextWidget(String text) {
    return Flexible(
        child: Text(
      text,
      overflow: TextOverflow.ellipsis,
    ));
  }

  @override
  Widget generateUnshrinkableTextWidget(String text) {
    return Flexible(
        child: Wrap(children: [
      Text(
        text,
        overflow: TextOverflow.ellipsis,
      )
    ]));
  }

  @override
  Widget generateShrinkableDotWidget() {
    return SizedBox(
      width: middleWidgetMinimalWidth,
    );
  }

  @override
  Widget generateUnshrinkableDotWidget() {
    return Expanded(
      flex: flexCoefficient,
      child: const DottedLine(),
    );
  }
}
