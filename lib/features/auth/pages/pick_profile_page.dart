import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/routes/app_routes.dart';

// ── Données profil ─────────────────────────────────────
class _ProfileData {
  final String name;
  final String emoji;
  final Color accent;
  final bool isKid;
  _ProfileData(this.name, this.emoji, this.accent, {this.isKid = false});
}

// ── Gamme d'emojis pour création de profil ─────────────
const kProfileEmojis = [
  // Humains
  '🧑🏿','👨🏿','👩🏿','🧒🏿','👴🏿','👵🏿',
  '🧑🏾','👨🏾','👩🏾','🧒🏾','👴🏾','👵🏾',
  // Animaux & nature
  '🦁','🐆','🦅','🐘','🦏','🐊','🦀','🐬','🦋','🦜',
  // Masques & culture gabonaise
  '🎭','🥁','🪘','🪗','🎪',
  // Abstraits / gaming
  '👾','🤖','👻','💀','🎮','🕹️',
  // Nature & cosmos
  '🌍','🌊','🌴','🌿','⚡','🔥','💧','🌙','☀️','🌟',
  // Sports & lifestyle
  '⚽','🏀','🎯','🎸','🎨','📚','✈️','🎬','🎵',
];

class PickProfilePage extends StatefulWidget {
  const PickProfilePage({super.key});
  @override
  State<PickProfilePage> createState() => _PickProfilePageState();
}

class _PickProfilePageState extends State<PickProfilePage>
    with TickerProviderStateMixin {

  // Profils démo (remplacés par API en prod)
  final List<_ProfileData> _profiles = [
    _ProfileData('Jean-Marie', '👨🏿', const Color(0xFFD0021B)),
    _ProfileData('Aminata',    '👩🏿', const Color(0xFF27AE60)),
    _ProfileData('Junior',     '🧒🏿', const Color(0xFF2D9CDB), isKid: true),
  ];

  int? _selectedIndex;
  bool _isManaging = false;
  late final AnimationController _shakeCtrl;
  late final Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnim = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _shakeCtrl, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    super.dispose();
  }

  void _selectProfile(int idx) {
    if (_isManaging) return;
    setState(() => _selectedIndex = idx);
    Future.delayed(const Duration(milliseconds: 320), () {
      Get.offAllNamed(AppRoutes.home);
    });
  }

  void _deleteProfile(int idx) {
    setState(() => _profiles.removeAt(idx));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(children: [
        // Fond radial subtil
        Positioned.fill(child: CustomPaint(painter: _BgPainter())),

        SafeArea(
          child: Column(children: [
            const SizedBox(height: 40),

            // ── Titre ─────────────────────────────────────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isManaging
                  ? Column(key: const ValueKey('manage'), children: [
                Text('GESTION', style: AppTextStyles.labelRed),
                const SizedBox(height: 6),
                const Text('Gérer les profils', style: AppTextStyles.display2),
              ])
                  : Column(key: const ValueKey('pick'), children: [
                Text('ACCÈS', style: AppTextStyles.labelRed),
                const SizedBox(height: 6),
                const Text('Qui regarde ?', style: AppTextStyles.display2),
              ]),
            ),
            const SizedBox(height: 8),
            const Text('Choisissez votre profil pour continuer',
                style: AppTextStyles.body2),

            const SizedBox(height: 48),

            // ── Grille de profils ─────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: _profiles.length + 1, // +1 pour "Ajouter"
                  itemBuilder: (_, i) {
                    if (i == _profiles.length) {
                      return _AddProfileTile(onTap: () => _showCreateSheet(context));
                    }
                    return _ProfileTile(
                      data: _profiles[i],
                      index: i,
                      isSelected: _selectedIndex == i,
                      isManaging: _isManaging,
                      onTap: () => _selectProfile(i),
                      onDelete: () => _deleteProfile(i),
                      onEdit: () => _showEditSheet(context, i),
                    );
                  },
                ),
              ),
            ),

            // ── Footer ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _isManaging
                    ? _buildManageFooter()
                    : _buildPickFooter(),
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _buildPickFooter() => Row(
    key: const ValueKey('pick_footer'),
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      GestureDetector(
        onTap: () => setState(() => _isManaging = true),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surfaceVar,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.tune_rounded, color: AppColors.primary, size: 16),
            const SizedBox(width: 8),
            const Text('Gérer les profils',
                style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600)),
          ]),
        ),
      ),
    ],
  );

  Widget _buildManageFooter() => SizedBox(
    key: const ValueKey('manage_footer'),
    width: double.infinity,
    child: FilledButton.icon(
      onPressed: () => setState(() => _isManaging = false),
      icon: const Icon(Icons.check_rounded, size: 18),
      label: const Text('Terminer'),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
  );

  // ── Sheet création profil ──────────────────────────────
  void _showCreateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProfileFormSheet(
        onSave: (name, emoji, accent) {
          setState(() => _profiles.add(_ProfileData(name, emoji, accent)));
          Get.back();
        },
      ),
    );
  }

  void _showEditSheet(BuildContext context, int idx) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProfileFormSheet(
        initial: _profiles[idx],
        onSave: (name, emoji, accent) {
          setState(() => _profiles[idx] = _ProfileData(name, emoji, accent));
          Get.back();
        },
      ),
    );
  }
}

// ── Tuile profil ───────────────────────────────────────
class _ProfileTile extends StatefulWidget {
  final _ProfileData data;
  final int index;
  final bool isSelected;
  final bool isManaging;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _ProfileTile({
    required this.data, required this.index, required this.isSelected,
    required this.isManaging, required this.onTap,
    required this.onDelete, required this.onEdit,
  });

  @override
  State<_ProfileTile> createState() => _ProfileTileState();
}

class _ProfileTileState extends State<_ProfileTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _scaleAnim = Tween<double>(begin: 1, end: 0.92).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) { _ctrl.reverse(); widget.onTap(); },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (_, child) => Transform.scale(scale: _scaleAnim.value, child: child),
        child: Column(children: [
          Stack(clipBehavior: Clip.none, children: [
            // Avatar
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 84, height: 84,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [
                    widget.data.accent.withOpacity(0.4),
                    widget.data.accent.withOpacity(0.1),
                  ],
                ),
                border: Border.all(
                  color: widget.isSelected
                      ? widget.data.accent
                      : widget.data.accent.withOpacity(0.25),
                  width: widget.isSelected ? 2.5 : 1.5,
                ),
                boxShadow: widget.isSelected ? [
                  BoxShadow(color: widget.data.accent.withOpacity(0.4), blurRadius: 20, spreadRadius: 2),
                ] : [],
              ),
              child: Center(
                child: Text(widget.data.emoji, style: const TextStyle(fontSize: 42)),
              ),
            ),

            // Badge kid
            if (widget.data.isKid)
              Positioned(top: -4, right: -4, child: Container(
                width: 22, height: 22,
                decoration: BoxDecoration(
                  color: const Color(0xFF2D9CDB),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.bg, width: 2),
                ),
                child: const Center(child: Text('👶', style: TextStyle(fontSize: 10))),
              )),

            // Badge managing : supprimer
            if (widget.isManaging)
              Positioned(top: -6, left: -6, child: GestureDetector(
                onTap: widget.onDelete,
                child: Container(
                  width: 24, height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.bg, width: 2),
                  ),
                  child: const Icon(Icons.remove, color: Colors.white, size: 14),
                ),
              )),

            // Badge managing : éditer
            if (widget.isManaging)
              Positioned(bottom: -6, right: -6, child: GestureDetector(
                onTap: widget.onEdit,
                child: Container(
                  width: 24, height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHigh,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border, width: 1.5),
                  ),
                  child: const Icon(Icons.edit_outlined, color: AppColors.textMuted, size: 12),
                ),
              )),

            // Checkmark si sélectionné
            if (widget.isSelected)
              Positioned.fill(child: Container(
                decoration: BoxDecoration(
                  color: widget.data.accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Center(child: Icon(Icons.check_circle_rounded,
                    color: widget.data.accent, size: 36)),
              )),
          ]),
          const SizedBox(height: 10),
          Text(widget.data.name,
            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w600),
            maxLines: 1, overflow: TextOverflow.ellipsis,
          ),
          if (widget.data.isKid)
            const Text('Enfant',
                style: TextStyle(fontSize: 10, color: Color(0xFF2D9CDB), fontFamily: 'monospace')),
        ]),
      ),
    );
  }
}

// ── Tuile Ajouter ─────────────────────────────────────
class _AddProfileTile extends StatelessWidget {
  final VoidCallback onTap;
  const _AddProfileTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(
          width: 84, height: 84,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: AppColors.surfaceVar,
            border: Border.all(color: AppColors.border, style: BorderStyle.solid, width: 1.5),
          ),
          child: const Center(child: Icon(Icons.add_rounded, color: AppColors.textMuted, size: 32)),
        ),
        const SizedBox(height: 10),
        const Text('Ajouter',
            style: TextStyle(fontSize: 13, color: AppColors.textMuted, fontWeight: FontWeight.w500)),
      ]),
    );
  }
}

// ── Sheet création/édition ─────────────────────────────
class _ProfileFormSheet extends StatefulWidget {
  final _ProfileData? initial;
  final void Function(String name, String emoji, Color accent) onSave;

  const _ProfileFormSheet({this.initial, required this.onSave});

  @override
  State<_ProfileFormSheet> createState() => _ProfileFormSheetState();
}

class _ProfileFormSheetState extends State<_ProfileFormSheet> {
  late String _selectedEmoji;
  late Color  _selectedAccent;
  late final TextEditingController _nameCtrl;
  int _emojiPage = 0;   // 0=Humains 1=Nature 2=Culture 3=Cosmos

  static const _accentColors = [
    Color(0xFFD0021B), Color(0xFF27AE60), Color(0xFF2D9CDB),
    Color(0xFFF5A623), Color(0xFF9B59B6), Color(0xFFE74C3C),
    Color(0xFF1ABC9C), Color(0xFFE67E22),
  ];

  static const _emojiCategories = [
    ('👤 Humains', ['🧑🏿','👨🏿','👩🏿','🧒🏿','👴🏿','👵🏿','🧑🏾','👨🏾','👩🏾','🧒🏾','👴🏾','👵🏾','🧑','👦','👧','🧔','👱','🧕']),
    ('🌿 Nature',  ['🦁','🐆','🦅','🐘','🦏','🐊','🦀','🐬','🦋','🦜','🌍','🌊','🌴','🌿','🦒','🦓','🐍','🌺']),
    ('🎭 Culture', ['🎭','🥁','🪘','🪗','🎪','🎬','🎵','🎸','🎨','📚','⚽','🏀','🎯','✈️','🏖️','🎡','🎢','🛸']),
    ('🌟 Cosmos',  ['⚡','🔥','💧','🌙','☀️','🌟','💫','🌈','❄️','🌊','🎆','🎇','✨','🔮','🌀','⭐','🌑','🌕']),
  ];

  @override
  void initState() {
    super.initState();
    _selectedEmoji  = widget.initial?.emoji  ?? '🧑🏿';
    _selectedAccent = widget.initial?.accent ?? _accentColors[0];
    _nameCtrl = TextEditingController(text: widget.initial?.name ?? '');
  }

  @override
  void dispose() { _nameCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: EdgeInsets.only(bottom: bottom + 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Handle
        const SizedBox(height: 12),
        Container(width: 40, height: 4,
            decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(4))),
        const SizedBox(height: 20),

        // Preview avatar
        Container(
          width: 88, height: 88,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [_selectedAccent.withOpacity(0.4), _selectedAccent.withOpacity(0.1)],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
            border: Border.all(color: _selectedAccent, width: 2),
            boxShadow: [BoxShadow(color: _selectedAccent.withOpacity(0.3), blurRadius: 20)],
          ),
          child: Center(child: Text(_selectedEmoji, style: const TextStyle(fontSize: 46))),
        ),
        const SizedBox(height: 16),

        // Nom
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: TextField(
            controller: _nameCtrl,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 1),
            decoration: InputDecoration(
              hintText: 'Nom du profil',
              hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 16),
              filled: true,
              fillColor: AppColors.surfaceVar,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: _selectedAccent, width: 1.5),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Tabs catégories emoji
        SizedBox(
          height: 32,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _emojiCategories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final active = i == _emojiPage;
              return GestureDetector(
                onTap: () => setState(() => _emojiPage = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: active ? _selectedAccent.withOpacity(0.2) : AppColors.surfaceVar,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: active ? _selectedAccent : AppColors.border),
                  ),
                  child: Text(_emojiCategories[i].$1,
                      style: TextStyle(fontSize: 11,
                          color: active ? _selectedAccent : AppColors.textMuted,
                          fontWeight: active ? FontWeight.w700 : FontWeight.normal)),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),

        // Grille emoji
        SizedBox(
          height: 130,
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8,
            ),
            itemCount: _emojiCategories[_emojiPage].$2.length,
            itemBuilder: (_, i) {
              final emoji = _emojiCategories[_emojiPage].$2[i];
              final selected = emoji == _selectedEmoji;
              return GestureDetector(
                onTap: () => setState(() => _selectedEmoji = emoji),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    color: selected ? _selectedAccent.withOpacity(0.2) : AppColors.surfaceVar,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: selected ? _selectedAccent : Colors.transparent),
                  ),
                  child: Center(child: Text(emoji, style: const TextStyle(fontSize: 26))),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // Couleurs accent
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _accentColors.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final c = _accentColors[i];
              final selected = c == _selectedAccent;
              return GestureDetector(
                onTap: () => setState(() => _selectedAccent = c),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: c, shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? Colors.white : Colors.transparent,
                      width: 2.5,
                    ),
                    boxShadow: selected ? [BoxShadow(color: c.withOpacity(0.5), blurRadius: 10)] : [],
                  ),
                  child: selected
                      ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                      : null,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),

        // Bouton sauvegarder
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                final name = _nameCtrl.text.trim();
                if (name.isEmpty) return;
                widget.onSave(name, _selectedEmoji, _selectedAccent);
              },
              style: FilledButton.styleFrom(
                backgroundColor: _selectedAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                widget.initial != null ? 'Enregistrer' : 'Créer le profil',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ]),
    );
  }
}

// ── Background painter ─────────────────────────────────
class _BgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, -0.6),
        radius: 0.8,
        colors: [const Color(0xFF1A0003), AppColors.bg],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }
  @override
  bool shouldRepaint(_) => false;
}