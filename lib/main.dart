import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_task/src/domain/interface/i_widget.dart';
import 'package:flutter_test_task/src/domain/service/i_widget_service.dart';
import 'package:get_it/get_it.dart';

void main() {
  GetIt.I.registerFactory<IWidget>(() => WidgetService());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ///Сервис виджетов
  final IWidget widgetService = GetIt.I.get<IWidget>();

  /// Значение для текста
  var text = "Какой-то текст";

  /// Значение для чекбокса
  var isChecked = true;

  /// При каком значение перестает сжиматься пунктирная линия
  var shrinkLimit = 240;

  /// Минимальная ширина
  var minimumWidth = 110.0;

  /// Начальное значения для слайдера
  var containerWidth = 0.0;

  /// Коэффициент для начального значения ширины
  var startMultiplier = 3;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          double cardWidth = containerWidth == 0
              ? (minimumWidth * startMultiplier)
              : containerWidth;
          var textWidget = cardWidth <= shrinkLimit
              ? widgetService.generateShrinkableTextWidget(text)
              : widgetService.generateUnshrinkableTextWidget(text);
          var dotWidget = cardWidth <= shrinkLimit
              ? widgetService.generateShrinkableDotWidget()
              : widgetService.generateUnshrinkableDotWidget();
          return Column(children: [
            Slider(
              max: constraints.maxWidth,
              min: minimumWidth,
              value: cardWidth,
              onChanged: (value) {
                setState(() {
                  cardWidth = value;
                  containerWidth = value;
                });
                print(value);
              },
            ),
            widgetService.generateResizableRow(
                cardWidth, textWidget, dotWidget, isChecked)
          ]);
        }));
  }

  Container generateResizableRow(
      double cardWidth, Widget textWidget, Widget dotWidget) {
    return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        width: cardWidth,
        child: IntrinsicHeight(
            child: Padding(
                padding: const EdgeInsets.all(5),
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
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  )
                ]))));
  }
}
