import 'package:flutter/material.dart';
import 'core/tokens.dart';
import 'core/i18n.dart';
import 'zones/academy/academy_home.dart';
import 'zones/radar/radar_home.dart';
import 'zones/portfolio/portfolio_home.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int i = 2; // arranca en SiPortfolio: la zona que engancha
  @override
  Widget build(BuildContext context) {
    final pages = const [AcademyHome(), RadarHome(), PortfolioHome()];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: T.navy, foregroundColor: T.white,
        title: Row(children: [
          // Lockup: casa-circulo + wordmark. Powered by SOLO aqui (P1B).
          Image.asset('assets/brand/logo_oficial_transparente.png',
              height: 28, errorBuilder: (_, __, ___) => const Icon(Icons.home, color: T.red)),
          const SizedBox(width: T.sp8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('JoinSi', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            Text('by HOMESI · Powered by Supreme Lending',
                style: TextStyle(fontSize: 9, color: T.sky)),
          ]),
        ]),
        actions: [
          TextButton(onPressed: l10n.toggle,
              child: Text(l10n.es ? 'EN' : 'ES', style: const TextStyle(color: T.yellow, fontWeight: FontWeight.w700))),
        ],
      ),
      body: AnimatedSwitcher(duration: T.durMid, switchInCurve: T.easeBrand, child: pages[i]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: i, onDestinationSelected: (v) => setState(() => i = v),
        indicatorColor: T.red.withOpacity(.12),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.school_outlined),
              selectedIcon: const Icon(Icons.school, color: T.red),
              label: l10n.t('Academy', 'SiAcademy')),
          NavigationDestination(icon: const Icon(Icons.radar_outlined),
              selectedIcon: const Icon(Icons.radar, color: T.red),
              label: 'SiRadar'),
          NavigationDestination(icon: const Icon(Icons.map_outlined),
              selectedIcon: const Icon(Icons.map, color: T.red),
              label: 'SiPortfolio'),
        ],
      ),
    );
  }
}
