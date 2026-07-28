import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'core/i18n.dart';
import 'data/store.dart';
import 'shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Store.init();
  runApp(const JoinSiApp());
}

class JoinSiApp extends StatelessWidget {
  const JoinSiApp({super.key});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: l10n,
      builder: (_, __) => MaterialApp(
          title: 'JoinSi by HOMESI',
          debugShowCheckedModeBanner: false,
          theme: joinSiTheme(),
          home: const Shell()));
}
