import 'package:flutter/material.dart';

import '../../../shared/layout/squad_screen_insets.dart';
import '../../../shared/visuals/squad_ping_assets.dart';
import '../../profile_center/services/coin_economy.dart';
import '../../profile_center/services/profile_wallet_store.dart';
import '../../profile_center/widgets/coin_feedback.dart';
import '../data/game_zone_seed.dart';
import '../models/game_zone_models.dart';
import '../models/tactical_brief_models.dart';
import '../services/tactical_brief_store.dart';

class TacticalBriefForgeScreen extends StatefulWidget {
  const TacticalBriefForgeScreen({super.key});

  @override
  State<TacticalBriefForgeScreen> createState() =>
      _TacticalBriefForgeScreenState();
}

class _TacticalBriefForgeScreenState extends State<TacticalBriefForgeScreen> {
  final _walletStore = ProfileWalletStore.instance;
  final _briefStore = TacticalBriefStore.instance;

  var _selectedGameIndex = 0;
  var _selectedObjectiveIndex = 0;
  var _selectedTempoIndex = 1;
  var _squadSize = 4;
  var _isReady = false;
  var _isForging = false;

  GameTitle get _selectedGame => GameZoneSeed.games[_selectedGameIndex];
  _BriefObjective get _selectedObjective =>
      _briefObjectives[_selectedObjectiveIndex];
  _TempoPreset get _selectedTempo => _tempoPresets[_selectedTempoIndex];

  @override
  void initState() {
    super.initState();
    _initialize();
    _walletStore.addListener(_refresh);
    _briefStore.addListener(_refresh);
  }

  @override
  void dispose() {
    _walletStore.removeListener(_refresh);
    _briefStore.removeListener(_refresh);
    super.dispose();
  }

  Future<void> _initialize() async {
    await Future.wait([_walletStore.initialize(), _briefStore.initialize()]);
    if (mounted) {
      setState(() => _isReady = true);
    }
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _forgeBrief() async {
    if (_isForging) {
      return;
    }
    setState(() => _isForging = true);

    final charged = await _walletStore.spendCoins(
      CoinEconomy.tacticalBriefCost,
    );
    if (!mounted) {
      return;
    }
    if (!charged) {
      setState(() => _isForging = false);
      await showInsufficientCoinsDialog(
        context,
        cost: CoinEconomy.tacticalBriefCost,
        balance: _walletStore.coins,
      );
      return;
    }

    await _briefStore.addBrief(_buildBrief());
    if (!mounted) {
      return;
    }
    setState(() => _isForging = false);
    showCoinSpentSnack(
      context,
      cost: CoinEconomy.tacticalBriefCost,
      balance: _walletStore.coins,
    );
  }

  TacticalBrief _buildBrief() {
    final now = DateTime.now();
    final game = _selectedGame;
    final objective = _selectedObjective;
    final tempo = _selectedTempo;
    final leadTag = game.tags.isEmpty ? 'teamplay' : game.tags.first;
    final roles = _rolesFor(game, _squadSize, tempo);

    return TacticalBrief(
      id: 'brief-${now.microsecondsSinceEpoch}',
      gameName: game.name,
      objective: objective.label,
      tempo: tempo.label,
      squadSize: _squadSize,
      title: '${game.name} ${objective.shortLabel}',
      summary:
          '${tempo.summary} Build around $leadTag, then convert the final window into a clean ${objective.payoff}.',
      lines: [
        'Warmup: ${objective.warmup} Keep it under eight minutes before queue.',
        'Comms: ${tempo.calloutRule} Use role, route, danger, reset.',
        'Roles: ${roles.join(' / ')}.',
        'Mid-run check: call one stop point before the team splits or overchases.',
        'Safety rule: no wagers, no harassment, and report abusive clips or chat.',
      ],
      createdAt: now,
      cost: CoinEconomy.tacticalBriefCost,
    );
  }

  List<String> _rolesFor(GameTitle game, int squadSize, _TempoPreset tempo) {
    final tags = game.tags;
    final primaryTag = tags.isEmpty ? 'map' : tags.first.toLowerCase();
    final secondaryTag = tags.length > 1 ? tags[1].toLowerCase() : 'route';
    final roles = <String>[
      'Caller: owns ${tempo.timerCue}',
      'Entry: opens first $primaryTag contact',
      'Scout: marks $secondaryTag risk',
      'Anchor: holds reset route',
      'Flex: covers trade timing',
      'Reviewer: captures one learning note',
    ];
    return roles.take(squadSize).toList(growable: false);
  }

  void _setSquadSize(int value) {
    setState(() => _squadSize = value.clamp(2, 6).toInt());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              SquadPingAssets.chatStrategyTable,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.58),
                    const Color(0xFF4A20D7).withValues(alpha: 0.80),
                    Colors.black.withValues(alpha: 0.88),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: !_isReady
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : ListView(
                        padding: EdgeInsets.fromLTRB(
                          16,
                          squadCompactTopPadding(context, extra: 4),
                          16,
                          32,
                        ),
                        children: [
                          _ForgeHeader(
                            onBack: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(height: 16),
                          _WalletStatus(
                            coins: _walletStore.coins,
                            cost: CoinEconomy.tacticalBriefCost,
                          ),
                          const SizedBox(height: 14),
                          _ForgePanel(
                            children: [
                              _SelectorSection(
                                title: 'Game focus',
                                children: [
                                  for (final entry
                                      in GameZoneSeed.games.asMap().entries)
                                    _ChoicePill(
                                      label: entry.value.name,
                                      isSelected:
                                          entry.key == _selectedGameIndex,
                                      onSelected: () {
                                        setState(
                                          () => _selectedGameIndex = entry.key,
                                        );
                                      },
                                    ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              _SelectorSection(
                                title: 'Squad objective',
                                children: [
                                  for (final entry
                                      in _briefObjectives.asMap().entries)
                                    _ChoicePill(
                                      label: entry.value.label,
                                      isSelected:
                                          entry.key == _selectedObjectiveIndex,
                                      onSelected: () {
                                        setState(
                                          () => _selectedObjectiveIndex =
                                              entry.key,
                                        );
                                      },
                                    ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              _SelectorSection(
                                title: 'Comms tempo',
                                children: [
                                  for (final entry
                                      in _tempoPresets.asMap().entries)
                                    _ChoicePill(
                                      label: entry.value.label,
                                      isSelected:
                                          entry.key == _selectedTempoIndex,
                                      onSelected: () {
                                        setState(
                                          () => _selectedTempoIndex = entry.key,
                                        );
                                      },
                                    ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              _SquadSizeStepper(
                                size: _squadSize,
                                onChanged: _setSquadSize,
                              ),
                              const SizedBox(height: 18),
                              SizedBox(
                                height: 52,
                                child: FilledButton.icon(
                                  onPressed: _isForging ? null : _forgeBrief,
                                  icon: _isForging
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Icon(Icons.bolt_rounded),
                                  label: Text(
                                    _isForging
                                        ? 'Forging brief'
                                        : 'Forge brief - ${CoinEconomy.tacticalBriefCost} coins',
                                  ),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFD85F),
                                    foregroundColor: const Color(0xFF211148),
                                    disabledBackgroundColor: Colors.white
                                        .withValues(alpha: 0.20),
                                    disabledForegroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _HistoryHeader(count: _briefStore.briefs.length),
                          const SizedBox(height: 12),
                          if (_briefStore.briefs.isEmpty)
                            const _EmptyBriefHistory()
                          else
                            for (final brief in _briefStore.briefs) ...[
                              _BriefCard(brief: brief),
                              const SizedBox(height: 12),
                            ],
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ForgeHeader extends StatelessWidget {
  const _ForgeHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.white,
        ),
        Expanded(
          child: Text(
            'Tactical Brief',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }
}

class _WalletStatus extends StatelessWidget {
  const _WalletStatus({required this.coins, required this.cost});

  final int coins;
  final int cost;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.32),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Image.asset(SquadPingAssets.profileCoinIcon, width: 34, height: 34),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Balance $coins coins',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD85F).withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'Fixed cost: $cost',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: const Color(0xFFFFE58A),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ForgePanel extends StatelessWidget {
  const _ForgePanel({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _SelectorSection extends StatelessWidget {
  const _SelectorSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.76),
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(spacing: 8, runSpacing: 8, children: children),
      ],
    );
  }
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 150),
        child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      showCheckmark: false,
      selectedColor: const Color(0xFFFFD85F),
      backgroundColor: Colors.black.withValues(alpha: 0.26),
      labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: isSelected ? const Color(0xFF241151) : Colors.white,
        fontWeight: FontWeight.w900,
      ),
      side: BorderSide(
        color: isSelected
            ? const Color(0xFFFFD85F)
            : Colors.white.withValues(alpha: 0.18),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    );
  }
}

class _SquadSizeStepper extends StatelessWidget {
  const _SquadSizeStepper({required this.size, required this.onChanged});

  final int size;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Squad seats',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          IconButton(
            onPressed: size > 2 ? () => onChanged(size - 1) : null,
            icon: const Icon(Icons.remove_rounded),
            color: Colors.white,
          ),
          SizedBox(
            width: 34,
            child: Text(
              '$size',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(0xFFFFD85F),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          IconButton(
            onPressed: size < 6 ? () => onChanged(size + 1) : null,
            icon: const Icon(Icons.add_rounded),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _HistoryHeader extends StatelessWidget {
  const _HistoryHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Brief history',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$count saved',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.62),
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _EmptyBriefHistory extends StatelessWidget {
  const _EmptyBriefHistory();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Text(
        'No brief yet. Forge one before queueing to give the squad clear roles, comms, and reset rules.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.white.withValues(alpha: 0.78),
          fontWeight: FontWeight.w700,
          height: 1.35,
        ),
      ),
    );
  }
}

class _BriefCard extends StatelessWidget {
  const _BriefCard({required this.brief});

  final TacticalBrief brief;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  brief.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF211148),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _BriefCostTag(cost: brief.cost),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _BriefMeta(label: brief.gameName),
              _BriefMeta(label: brief.objective),
              _BriefMeta(label: '${brief.squadSize} seats'),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            brief.summary,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF403651),
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          for (final line in brief.lines) ...[
            _BriefLine(text: line),
            const SizedBox(height: 7),
          ],
        ],
      ),
    );
  }
}

class _BriefCostTag extends StatelessWidget {
  const _BriefCostTag({required this.cost});

  final int cost;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF7138F5).withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(SquadPingAssets.profileCoinIcon, width: 16, height: 16),
          const SizedBox(width: 4),
          Text(
            '$cost',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: const Color(0xFF7138F5),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _BriefMeta extends StatelessWidget {
  const _BriefMeta({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF211148).withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: const Color(0xFF58496C),
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _BriefLine extends StatelessWidget {
  const _BriefLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 5),
          child: Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF7138F5),
            size: 17,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: const Color(0xFF2C2438),
              fontWeight: FontWeight.w800,
              height: 1.28,
            ),
          ),
        ),
      ],
    );
  }
}

class _BriefObjective {
  const _BriefObjective({
    required this.label,
    required this.shortLabel,
    required this.warmup,
    required this.payoff,
  });

  final String label;
  final String shortLabel;
  final String warmup;
  final String payoff;
}

class _TempoPreset {
  const _TempoPreset({
    required this.label,
    required this.summary,
    required this.calloutRule,
    required this.timerCue,
  });

  final String label;
  final String summary;
  final String calloutRule;
  final String timerCue;
}

const _briefObjectives = <_BriefObjective>[
  _BriefObjective(
    label: 'Ranked push',
    shortLabel: 'ranked plan',
    warmup: 'run one mechanics check and one route check.',
    payoff: 'ranked finish',
  ),
  _BriefObjective(
    label: 'Clip capture',
    shortLabel: 'clip plan',
    warmup: 'pick one highlight angle and one backup role.',
    payoff: 'shareable clip',
  ),
  _BriefObjective(
    label: 'Scrim review',
    shortLabel: 'scrim plan',
    warmup: 'choose the single mistake the squad wants to test.',
    payoff: 'review note',
  ),
  _BriefObjective(
    label: 'New teammate trial',
    shortLabel: 'trial plan',
    warmup: 'name roles first so the new teammate knows the lane.',
    payoff: 'clean trial run',
  ),
  _BriefObjective(
    label: 'Comeback reset',
    shortLabel: 'reset plan',
    warmup: 'clear tilted comms and pick one safe opener.',
    payoff: 'stable reset',
  ),
];

const _tempoPresets = <_TempoPreset>[
  _TempoPreset(
    label: 'Quiet',
    summary: 'A low-noise plan for tense or late-night games.',
    calloutRule: 'Only the caller speaks during contact.',
    timerCue: 'reset windows',
  ),
  _TempoPreset(
    label: 'Balanced',
    summary: 'A steady plan for mixed squads and normal queue pressure.',
    calloutRule: 'Short calls first, details after the fight.',
    timerCue: 'objective timing',
  ),
  _TempoPreset(
    label: 'Fast',
    summary: 'A quick plan for confident teams that want early pressure.',
    calloutRule: 'Entry calls direction, anchor calls stop.',
    timerCue: 'push timing',
  ),
];
