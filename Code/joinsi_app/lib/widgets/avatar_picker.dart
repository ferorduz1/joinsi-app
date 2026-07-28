// Selector de carita — asigna la identidad visual de un LO: expresion, forma,
// color de paleta o foto real desde galeria. Persistente via Store.
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/tokens.dart';
import '../core/i18n.dart';
import '../data/store.dart';
import '../models/loan_officer.dart';
import 'carita_avatar.dart';

Future<void> showAvatarPicker(BuildContext context, LoanOfficer lo,
    {VoidCallback? onSaved}) async {
  await showModalBottomSheet(
    context: context, isScrollControlled: true,
    backgroundColor: T.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(T.rBig))),
    builder: (_) => _AvatarPickerSheet(lo: lo, onSaved: onSaved),
  );
}

class _AvatarPickerSheet extends StatefulWidget {
  final LoanOfficer lo;
  final VoidCallback? onSaved;
  const _AvatarPickerSheet({required this.lo, this.onSaved});
  @override
  State<_AvatarPickerSheet> createState() => _AvatarPickerSheetState();
}

class _AvatarPickerSheetState extends State<_AvatarPickerSheet> {
  late AvatarSpec spec = widget.lo.avatar;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(left: T.sp24, right: T.sp24, top: T.sp16,
            bottom: MediaQuery.of(context).viewInsets.bottom + T.sp24),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l10n.t('IDENTITY ON THE MAP', 'IDENTIDAD EN EL MAPA'),
                style: tt.labelSmall!.copyWith(color: T.red)),
            const SizedBox(height: T.sp4),
            Text(widget.lo.name, style: tt.headlineSmall),
            const SizedBox(height: T.sp16),
            // Preview + foto
            Row(children: [
              CaritaAvatar(spec: spec, size: 72, ring: true),
              const SizedBox(width: T.sp16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                OutlinedButton.icon(
                  onPressed: _pickPhoto,
                  icon: const Icon(Icons.photo_camera_outlined, size: 18),
                  label: Text(l10n.t('Use real photo', 'Usar foto real')),
                ),
                if (spec.photoPath != null)
                  TextButton(
                      onPressed: () => setState(() =>
                          spec = spec.copyWith(clearPhoto: true)),
                      child: Text(l10n.t('Remove photo, use carita',
                          'Quitar foto, usar carita'),
                          style: const TextStyle(color: T.neutralText))),
              ])),
            ]),
            const SizedBox(height: T.sp24),
            Text(l10n.t('EXPRESSION', 'EXPRESIÓN'), style: tt.labelSmall),
            const SizedBox(height: T.sp8),
            Wrap(spacing: T.sp12, runSpacing: T.sp12, children: [
              for (var f = 0; f < 8; f++)
                _option(selected: spec.photoPath == null && spec.face == f,
                    onTap: () => setState(() =>
                        spec = spec.copyWith(face: f, clearPhoto: true)),
                    child: Tooltip(message: faceNames()[f],
                      child: CaritaAvatar(
                        spec: AvatarSpec(face: f, shape: spec.shape, color: spec.color),
                        size: 44))),
            ]),
            const SizedBox(height: T.sp16),
            Text(l10n.t('SHAPE', 'FORMA'), style: tt.labelSmall),
            const SizedBox(height: T.sp8),
            Wrap(spacing: T.sp12, children: [
              for (var s = 0; s < 4; s++)
                _option(selected: spec.shape == s,
                    onTap: () => setState(() => spec = spec.copyWith(shape: s)),
                    child: Tooltip(message: shapeNames()[s],
                      child: CaritaAvatar(
                        spec: AvatarSpec(face: spec.face, shape: s, color: spec.color),
                        size: 44))),
            ]),
            const SizedBox(height: T.sp16),
            Text('COLOR', style: tt.labelSmall),
            const SizedBox(height: T.sp8),
            Wrap(spacing: T.sp12, children: [
              for (var c = 0; c < kAvatarCombos.length; c++)
                _option(selected: spec.color == c,
                    onTap: () => setState(() => spec = spec.copyWith(color: c)),
                    child: CaritaAvatar(
                        spec: AvatarSpec(face: spec.face, shape: spec.shape, color: c),
                        size: 44)),
            ]),
            const SizedBox(height: T.sp24),
            SizedBox(width: double.infinity, child: ElevatedButton(
              onPressed: () async {
                widget.lo.avatar = spec;
                await Store.saveLo(widget.lo);
                if (mounted) Navigator.pop(context);
                widget.onSaved?.call();
              },
              child: Text(l10n.t('SAVE IDENTITY', 'GUARDAR IDENTIDAD')),
            )),
          ]),
        ),
      ),
    );
  }

  Widget _option({required bool selected, required VoidCallback onTap,
      required Widget child}) =>
    GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: T.durFast, curve: T.easeBrand,
        padding: const EdgeInsets.all(T.sp4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),   // envuelve un avatar
          border: Border.all(width: 2,
              color: selected ? T.red : Colors.transparent),
        ),
        child: child,
      ),
    );

  Future<void> _pickPhoto() async {
    try {
      final x = await ImagePicker().pickImage(
          source: ImageSource.gallery, maxWidth: 512, maxHeight: 512);
      if (!mounted) return;
      if (x != null) setState(() => spec = spec.copyWith(photoPath: x.path));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(l10n.t('Gallery not available on this device',
              'Galería no disponible en este dispositivo'))));
    }
  }
}
