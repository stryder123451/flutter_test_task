import 'package:flutter/material.dart';

///Сервис виджетов
abstract class IWidget {
  /// Генерация виджета
  /// [cardWidth] ширина ряда
  /// [textWidget] виджет для текста
  /// [dotWidget] виджет для пунктирной линии
  /// [isChecked] значение для чекбокса
  Widget generateResizableRow(
      double cardWidth, Widget textWidget, Widget dotWidget, bool isChecked);

  /// Генерация сужаемого текстового виджета
  /// [text] текст
  Widget generateShrinkableTextWidget(String text);

  /// Генерация постоянного текстового виджета
  /// [text] текст
  Widget generateUnshrinkableTextWidget(String text);

  /// Генерация сужаемого виджета пунктирной линии
  Widget generateShrinkableDotWidget();

  /// Генерация постоянного виджета пунктирной линии
  Widget generateUnshrinkableDotWidget();
}
