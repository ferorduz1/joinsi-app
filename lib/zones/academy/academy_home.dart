// P10 Mapa de Aprendizaje - stub navegable (A5 completa simuladores y videos).
import 'package:flutter/material.dart';
import '../../core/tokens.dart';
import '../../core/i18n.dart';
import '../../data/store.dart';

class AcademyHome extends StatelessWidget {
  const AcademyHome({super.key});
  @override
  Widget build(BuildContext context) {
    final nodes = [
      ('Latino Niche LOs', Icons.play_circle_fill, T.red, true),
      ('The Recruiting Flow', Icons.play_circle_fill, T.red, true),
      ('Pricing: the Hook', Icons.play_circle_fill, T.red, true),
      ('The 225 bps Compensation', Icons.play_circle_fill, T.red, false),
      ('Objection Simulator', Icons.mic, T.navy, false),
      ('Live Call Simulator', Icons.phone_in_talk, T.navy, false),
      ('Time Blocking', Icons.calendar_month, T.navy, false),
      ('Final Exam', Icons.star, T.yellow, false),
    ];
    return ListView(padding: const EdgeInsets.all(T.sp16), children: [
      Text(l10n.t('Your path to SiPartner', 'Tu camino a SiPartner'),
          style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: T.sp8),
      ClipRRect(borderRadius: BorderRadius.circular(T.rChip),
          child: LinearProgressIndicator(value: Store.academyProgress,
              minHeight: 10, backgroundColor: T.competitorGray, color: T.yellow)),
      const SizedBox(height: T.sp4),
      Text('${(Store.academyProgress * 100).round()}% ${l10n.t("to SiPartner", "hacia SiPartner")}',
          style: Theme.of(context).textTheme.bodyMedium),
      const SizedBox(height: T.sp24),
      for (var i = 0; i < nodes.length; i++)
        Padding(
          padding: EdgeInsets.only(bottom: T.sp16,
              left: i.isEven ? 0 : T.sp48, right: i.isEven ? T.sp48 : 0),
          child: Card(child: ListTile(
            leading: CircleAvatar(backgroundColor: nodes[i].$4 ? nodes[i].$3 : T.competitorGray,
                child: Icon(nodes[i].$4 ? nodes[i].$2 : Icons.lock,
                    color: nodes[i].$4
                        ? (nodes[i].$3 == T.yellow ? T.navy : T.white)
                        : T.neutralText)),
            title: Text(nodes[i].$1, style: const TextStyle(fontWeight: FontWeight.w600)),
            trailing: nodes[i].$4
                ? const Text('✓', style: TextStyle(color: T.yellow, fontSize: 22, fontWeight: FontWeight.w700))
                : null,
          )),
        ),
    ]);
  }
}
