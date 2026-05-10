import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/core/constants/app_strings.dart';
import 'app/core/services/user_session_service.dart';
import 'app/core/theme/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize locale data for intl (Indonesian)
  await initializeDateFormatting('id_ID', null);

  // Initialize UserSessionService
  await Get.putAsync<UserSessionService>(() => UserSessionService().init());

  runApp(const BersihInApp());
}

class BersihInApp extends StatelessWidget {
  const BersihInApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
    );
  }
}
