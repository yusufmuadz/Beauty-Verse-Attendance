import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/controllers/api_controller.dart';
import 'app/controllers/model_controller.dart';
import 'app/modules/camera_capture/controllers/camera_capture_controller.dart';
import 'app/modules/home/views/menu_view.dart';
import 'app/modules/splash/bindings/splash_binding.dart';
import 'app/modules/splash/views/splash_view.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

/// Custom HTTP overrides to handle bad certificates.
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// perbaikan untuk APP_ID
Future<void> main() async {
  // Initialize Flutter bindings and Firebase.
  WidgetsFlutterBinding.ensureInitialized();

  // if (Firebase.apps.isEmpty) {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  // }

  HttpOverrides.global = MyHttpOverrides();

  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
  }

  await Hive.initFlutter();
  await Hive.openBox("andioffset");

  await initializeDateFormatting("id_ID", null);

  // Register controllers with GetX.
  Get.put(ModelController(), permanent: true);
  Get.put(CameraCaptureController()).cameras(await availableCameras());

  // Run the app.
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final ApiController controller = Get.put(ApiController());
  final ModelController model = Get.find<ModelController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Handle app lifecycle state changes.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        // Calculate time spent in the background.
        final timeInBackground = DateTime.now().difference(
          model.pausedTime.value,
        );
        if (timeInBackground.inSeconds > 255) {
          await controller.todayAttendance();
          Get.offAll(() => MenuView(), transition: Transition.cupertino);
        }
        break;

      case AppLifecycleState.inactive:
        log("App is in inactive state");
        break;

      case AppLifecycleState.paused:
        model.pausedTime.value = DateTime.now();
        log("App is in paused state");
        break;

      case AppLifecycleState.detached:
        model.pausedTime.value = DateTime.now();
        log("App has been removed");
        break;

      case AppLifecycleState.hidden:
        log("App is in hidden state");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: SafeArea(top: false, bottom: true, child: child!),
      ),
      theme: _customTheme(),
      debugShowCheckedModeBanner: false,
      title: "Andi SIAP",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      unknownRoute: GetPage(
        name: '/notfound',
        page: () => const SplashView(),
        binding: SplashBinding(),
      ),
      locale: const Locale('en', 'US'),
      supportedLocales: const [Locale('id', 'ID')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }

  /// Custom theme configuration.
  ThemeData _customTheme() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: HexColor('#FEFDF9'),
      textTheme: GoogleFonts.varelaRoundTextTheme(),
      primaryTextTheme: GoogleFonts.varelaRoundTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.amber.shade900,
        titleTextStyle: GoogleFonts.outfit(
          fontWeight: FontWeight.normal,
          color: Colors.white,
          fontSize: 14,
        ),
        elevation: 1.5,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: HexColor('#FEFDF9'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(10)),
        ),
      ),
      bottomAppBarTheme: BottomAppBarThemeData(surfaceTintColor: Colors.white),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: HexColor('C3E54B'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textTheme: ButtonTextTheme.primary,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: HexColor('C3E54B'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.quicksand(),
        ),
      ),
    );
  }
}
