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
      title: 'Flutter тестовое задание',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter тестовое задание'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  ///Сервис виджетов
  final IWidget widgetService = GetIt.I.get<IWidget>();

  /// Значение для текста
  var text = "";

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

  /// Радиус округления для контроллера
  var controllerBorderRadius = 24.0;

  /// Размер шрифта для контроллера
  var textFontSize = 16.0;

  /// Размер экрана
  late Size screenSize;

  /// Контроллер для ввода текста
  TextEditingController textController =
      TextEditingController(text: "Какой то очень длинный предлинный текст");

  /// Высота для контроллера текста
  double textControllerHeight = 70;

  /// Отступы для контроллера текста
  double textControllerPadding = 20;

  /// Отступы для текста в контроллере
  EdgeInsetsGeometry edgeInsets = EdgeInsets.fromLTRB(28, 14, 0, 14);

  /// Коэффициент изменения слайдер во время уменьшения экрана
  double screenResizeSafeCoefficient = 0.8;

  /// Минимальная безопасная ширина экрана
  double safeScreenWidth = 10;

  /// Толщина границ контроллера
  double controllerBorderWidth = 3;

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    try {
      return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            var maxScreenWidth = constraints.maxWidth;

            double minCardWidth = minimumWidth > constraints.maxWidth
                ? safeScreenWidth
                : minimumWidth;

            double cardWidth =
                (containerWidth == 0 || containerWidth > maxScreenWidth)
                    ? calculateSliderOverflow(maxScreenWidth)
                    : containerWidth;

            var textWidget = cardWidth <= shrinkLimit
                ? widgetService.generateShrinkableTextWidget(text)
                : widgetService.generateUnshrinkableTextWidget(text);
            var dotWidget = cardWidth <= shrinkLimit
                ? widgetService.generateShrinkableDotWidget()
                : widgetService.generateUnshrinkableDotWidget();

            return Column(children: [
              Slider(
                max: maxScreenWidth,
                min: minCardWidth,
                label: cardWidth.round().toString(),
                value: cardWidth,
                onChanged: (value) {
                  setState(() {
                    cardWidth = value;
                    containerWidth = value;
                  });
                },
              ),
              const Divider(),
              widgetService.generateResizableRow(
                  cardWidth, textWidget, dotWidget, isChecked),
              const Divider(),
              Padding(
                padding: EdgeInsets.only(
                    left: textControllerPadding, right: textControllerPadding),
                child: SizedBox(
                  height: textControllerHeight,
                  width: screenSize.width,
                  child: TextField(
                    controller: textController,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(fontSize: textFontSize),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(controllerBorderRadius)),
                            borderSide: BorderSide(
                                width: controllerBorderWidth,
                                color: Colors.transparent)),
                        contentPadding: edgeInsets,
                        filled: true,
                        hintText: "Введите текст для отображения",
                        prefixIcon: const Icon(
                          Icons.swap_horizontal_circle,
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(
                                Radius.circular(controllerBorderRadius)))),
                  ),
                ),
              )
            ]);
          }));
    } catch (e) {
      return Scaffold(
          body: Center(
              child: Column(
        children: const [
          Text("Что-то не так :С ...."),
          CircularProgressIndicator(),
        ],
      )));
    }
  }

  double calculateSliderOverflow(double maxScreenWidth) {
    return maxScreenWidth * screenResizeSafeCoefficient < minimumWidth
        ? minimumWidth
        : maxScreenWidth * screenResizeSafeCoefficient;
  }

  @override
  void initState() {
    text = textController.text;
    textController.addListener(() {
      setState(() {
        text = textController.text;
      });
    });
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    setState(() {
      screenSize = MediaQuery.of(context).size;
      containerWidth > screenSize.width
          ? containerWidth = screenSize.width
          : containerWidth;
    });
  }
}
