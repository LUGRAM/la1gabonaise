import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controller/profile_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_snackbar.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey  = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _bioCtrl;

  // Avatar
  String _selectedEmoji = '👨🏿';
  String _selectedColor = '#8B0000';
  bool _isSaving = false;

  static const _avatarEmojis = [
    '👨🏿','👩🏿','👨🏾','👩🏾','👨🏽','👩🏽',
    '🧑🏿','🧑🏾','👦🏿','👧🏿','🧔🏿','👱🏿',
    '🦁','🐆','🦅','🌿','⚡','🎬',
  ];

  static const _avatarColors = [
    '#8B0000','#D0021B','#1A237E','#006400',
    '#4A148C','#E65100','#1B5E20','#37474F',
  ];

  @override
  void initState() {
    super.initState();
    final ctrl = Get.find<ProfileController>();
    _nameCtrl  = TextEditingController(text: ctrl.userName);
    _phoneCtrl = TextEditingController(text: '077 00 00 00');
    _emailCtrl = TextEditingController(text: 'utilisateur@email.com');
    _bioCtrl   = TextEditingController();
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _phoneCtrl.dispose();
    _emailCtrl.dispose(); _bioCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 800)); // mock API
    if (mounted) {
      setState(() => _isSaving = false);
      AppSnackbar.success('Profil mis à jour');
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
          onPressed: () => Get.back(),
        ),
        title: const Text('Modifier le profil',
            style: TextStyle(fontFamily: 'Playfair', fontSize: 18,
                fontWeight: FontWeight.w800, color: Colors.white)),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(width: 16, height: 16,
                child: CircularProgressIndicator(
                    color: AppColors.primary, strokeWidth: 2))
                : const Text('Enregistrer',
                style: TextStyle(color: AppColors.primary,
                    fontWeight: FontWeight.w700, fontSize: 13)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 60),
        child: Form(key: _formKey, child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Avatar ────────────────────────────────
            Center(child: Column(children: [
              const SizedBox(height: 16),
              Stack(alignment: Alignment.bottomRight, children: [
                Container(
                  width: 88, height: 88,
                  decoration: BoxDecoration(
                    color: Color(int.parse('0xFF${_selectedColor.replaceAll('#', '')}')),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.primary, width: 2),
                    boxShadow: [BoxShadow(
                        color: AppColors.primary.withOpacity(0.3), blurRadius: 20)],
                  ),
                  child: Center(child: Text(_selectedEmoji,
                      style: const TextStyle(fontSize: 40))),
                ),
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                      color: AppColors.primary, shape: BoxShape.circle,
                      border: Border.all(color: AppColors.bg, width: 2)),
                  child: const Icon(Icons.edit_rounded, color: Colors.white, size: 14),
                ),
              ]),
              const SizedBox(height: 16),
            ])),

            // ── Choix emoji ───────────────────────────
            _sectionLabel('AVATAR'),
            const SizedBox(height: 10),
            Wrap(spacing: 10, runSpacing: 10, children: _avatarEmojis.map((e) =>
                GestureDetector(
                  onTap: () => setState(() => _selectedEmoji = e),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: _selectedEmoji == e ? AppColors.primary : AppColors.surfaceVar,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: _selectedEmoji == e ? AppColors.primary : AppColors.border),
                    ),
                    child: Center(child: Text(e, style: const TextStyle(fontSize: 22))),
                  ),
                )
            ).toList()),

            const SizedBox(height: 16),

            // ── Couleur fond avatar ────────────────────
            _sectionLabel('COULEUR'),
            const SizedBox(height: 10),
            Row(children: _avatarColors.map((hex) {
              final selected = hex == _selectedColor;
              final col = Color(int.parse('0xFF${hex.replaceAll('#', '')}'));
              return GestureDetector(
                onTap: () => setState(() => _selectedColor = hex),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: selected ? 36 : 30,
                  height: selected ? 36 : 30,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: col, shape: BoxShape.circle,
                    border: Border.all(
                        color: selected ? Colors.white : Colors.transparent,
                        width: 2),
                    boxShadow: selected ? [BoxShadow(color: col.withOpacity(0.5), blurRadius: 8)] : [],
                  ),
                  child: selected
                      ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                      : null,
                ),
              );
            }).toList()),

            const SizedBox(height: 28),

            // ── Informations personnelles ──────────────
            _sectionLabel('INFORMATIONS'),
            const SizedBox(height: 14),

            _field(
              label: 'Nom complet',
              controller: _nameCtrl,
              icon: Icons.person_outline_rounded,
              validator: (v) => (v == null || v.trim().length < 2)
                  ? 'Minimum 2 caractères' : null,
            ),
            const SizedBox(height: 14),
            _field(
              label: 'Téléphone',
              controller: _phoneCtrl,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              hint: '077 00 00 00',
            ),
            const SizedBox(height: 14),
            _field(
              label: 'Email',
              controller: _emailCtrl,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) => (v != null && v.contains('@'))
                  ? null : 'Email invalide',
            ),
            const SizedBox(height: 14),
            _field(
              label: 'Bio (optionnel)',
              controller: _bioCtrl,
              icon: Icons.edit_note_rounded,
              hint: 'Quelques mots sur vous...',
              maxLines: 3,
            ),

            const SizedBox(height: 32),

            // ── Changer mot de passe ───────────────────
            _sectionLabel('SÉCURITÉ'),
            const SizedBox(height: 14),
            _actionTile(
              icon: Icons.lock_outline_rounded,
              label: 'Changer le mot de passe',
              onTap: () => _showChangePasswordSheet(context),
            ),
            const SizedBox(height: 8),
            _actionTile(
              icon: Icons.delete_outline_rounded,
              label: 'Supprimer mon compte',
              isRed: true,
              onTap: () => _showDeleteSheet(context),
            ),
          ],
        )),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: ElevatedButton(
            onPressed: _isSaving ? null : _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: _isSaving
                ? const SizedBox(width: 20, height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Enregistrer les modifications',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          ),
        ),
      ),
    );
  }

  // ── Widgets helpers ───────────────────────────────────
  Widget _sectionLabel(String text) => Text(text,
      style: const TextStyle(fontSize: 10, fontFamily: 'monospace',
          letterSpacing: 2.5, color: AppColors.textMuted, fontWeight: FontWeight.w700));

  Widget _field({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted,
        fontFamily: 'monospace', fontWeight: FontWeight.w600)),
    const SizedBox(height: 6),
    TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.textMuted, size: 18),
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textDisabled, fontSize: 13),
        filled: true, fillColor: AppColors.surfaceVar,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.error)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    ),
  ]);

  Widget _actionTile({
    required IconData icon, required String label,
    required VoidCallback onTap, bool isRed = false,
  }) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceVar,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isRed
            ? AppColors.error.withOpacity(0.3) : AppColors.border),
      ),
      child: Row(children: [
        Icon(icon, color: isRed ? AppColors.error : AppColors.textMuted, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(label,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                color: isRed ? AppColors.error : AppColors.textPrimary))),
        Icon(Icons.chevron_right_rounded,
            color: isRed ? AppColors.error : AppColors.textDisabled, size: 18),
      ]),
    ),
  );

  // ── Sheet changement de mot de passe ─────────────────
  void _showChangePasswordSheet(BuildContext context) {
    final oldCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confCtrl = TextEditingController();
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      backgroundColor: AppColors.surfaceVar,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 20, right: 20, top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Text('Changer le mot de passe',
                style: TextStyle(fontFamily: 'Playfair', fontSize: 16,
                    fontWeight: FontWeight.w800, color: Colors.white)),
            const Spacer(),
            GestureDetector(onTap: () => Get.back(),
                child: const Icon(Icons.close_rounded, color: AppColors.textMuted, size: 20)),
          ]),
          const SizedBox(height: 20),
          _field(label: 'Mot de passe actuel', controller: oldCtrl,
              icon: Icons.lock_outline_rounded),
          const SizedBox(height: 12),
          _field(label: 'Nouveau mot de passe', controller: newCtrl,
              icon: Icons.lock_reset_rounded),
          const SizedBox(height: 12),
          _field(label: 'Confirmer', controller: confCtrl,
              icon: Icons.check_circle_outline_rounded),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Get.back();
              AppSnackbar.success('Mot de passe mis à jour');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary, foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Confirmer', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
        ]),
      ),
    );
  }

  // ── Sheet suppression compte ──────────────────────────
  void _showDeleteSheet(BuildContext context) {
    showModalBottomSheet(
      context: context, backgroundColor: AppColors.surfaceVar,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('⚠️', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          const Text('Supprimer mon compte',
              style: TextStyle(fontFamily: 'Playfair', fontSize: 18,
                  fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 8),
          const Text(
              'Cette action est irréversible. Toutes vos données, '
                  'historique et téléchargements seront supprimés.',
              style: TextStyle(fontSize: 13, color: AppColors.textMuted, height: 1.5),
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () { Get.back(); AppSnackbar.error('Fonctionnalité non disponible'); },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error, foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Supprimer définitivement',
                style: TextStyle(fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Annuler',
                style: TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w600)),
          ),
        ]),
      ),
    );
  }
}