import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/app_config.dart';
import 'services/admob_service.dart';
import 'services/wallet_service.dart';
import 'ui/home_screen.dart';
import 'ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await MobileAds.instance.initialize();
  final prefs = await SharedPreferences.getInstance();
  runApp(HakPayApp(wallet: WalletService(prefs)));
}

class HakPayApp extends StatefulWidget {
  const HakPayApp({super.key, required this.wallet});
  final WalletService wallet;

  @override
  State<HakPayApp> createState() => _HakPayAppState();
}

class _HakPayAppState extends State<HakPayApp> {
  @override
  void initState() {
    super.initState();
    AdMobService.instance.initialize();
  }

  @override
  void dispose() {
    AdMobService.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'HakPay',
        theme: HakTheme.dark(),
        home: HomeScreen(wallet: widget.wallet),
      );
}

// Referans: AppConfig.appId AndroidManifest'te kullanılır.
// ignore: unused_element
void _keepConfigReference() => debugPrint(AppConfig.appId);
