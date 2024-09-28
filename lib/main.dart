import 'package:celeryviz_frontend_core/celeryviz_frontend_core.dart';
import 'package:celeryviz_frontend_core/services/data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

const desktopPlatforms = [
  TargetPlatform.linux,
  TargetPlatform.macOS,
  TargetPlatform.windows,
];

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        appBar: null,
        body: AppWidget(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final DataSource dataSource =
      NDJsonDataSource(filePath: "assets/recording.ndjson");

  final isNotDesktopPlatform =
      !desktopPlatforms.contains(defaultTargetPlatform);

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (isNotDesktopPlatform) {
        const snackbar = SnackBar(
          showCloseIcon: true,
          duration: Duration(seconds: 30),
          content: Text(
              "This app is designed for desktops. For the best experience, try it on your computer!"),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CeleryMonitoringCore(
      dataSource: dataSource,
    );
  }
}
