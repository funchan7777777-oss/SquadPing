import 'package:flutter/material.dart';

import '../../../shared/visuals/squad_ping_assets.dart';
import '../widgets/full_bleed_asset_stage.dart';
import '../widgets/gate_text_action_button.dart';

class GuidedSignalTrack extends StatefulWidget {
  const GuidedSignalTrack({super.key, required this.onTrackCompleted});

  final VoidCallback onTrackCompleted;

  @override
  State<GuidedSignalTrack> createState() => _GuidedSignalTrackState();
}

class _GuidedSignalTrackState extends State<GuidedSignalTrack> {
  final PageController _guideController = PageController();
  int _focusedStep = 0;

  static const _guideCards = [
    _GuideCardCopy(
      assetPath: SquadPingAssets.appMark,
      headline: 'Catch the group pulse',
      detail: 'Keep each plan, reply, and late nudge in one friendly lane.',
    ),
    _GuideCardCopy(
      assetPath: SquadPingAssets.rallyArtifact,
      headline: 'Turn maybes into timing',
      detail: 'See who is close, who needs a reminder, and where the rally sits.',
    ),
    _GuideCardCopy(
      assetPath: SquadPingAssets.profileBadge,
      headline: 'Bring your own signal',
      detail: 'Add a name, photo, and signature so the squad knows it is you.',
    ),
  ];

  @override
  void dispose() {
    _guideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FullBleedAssetStage(
      backdropAsset: SquadPingAssets.background,
      foreground: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _guideController,
            onPageChanged: (index) => setState(() => _focusedStep = index),
            itemCount: _guideCards.length,
            itemBuilder: (context, index) {
              final card = _guideCards[index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(30, 122, 30, 170),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: index == 1 ? 178 : 156,
                      height: index == 1 ? 178 : 156,
                      padding: EdgeInsets.all(index == 1 ? 0 : 18),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.18),
                        ),
                      ),
                      child: Image.asset(card.assetPath, fit: BoxFit.contain),
                    ),
                    const SizedBox(height: 48),
                    Text(
                      card.headline,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        height: 1.08,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      card.detail,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.84),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 112,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var index = 0; index < _guideCards.length; index++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: _focusedStep == index ? 26 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        alpha: _focusedStep == index ? 0.95 : 0.42,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 42,
            child: Center(
              child: GateTextActionButton(
                caption: _focusedStep == _guideCards.length - 1
                    ? 'Enter'
                    : 'Next',
                semanticLabel: 'Continue guide',
                onPressed: _advanceGuide,
                widthFactor: 0.58,
                maxWidth: 238,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _advanceGuide() {
    if (_focusedStep == _guideCards.length - 1) {
      widget.onTrackCompleted();
      return;
    }
    _guideController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }
}

class _GuideCardCopy {
  const _GuideCardCopy({
    required this.assetPath,
    required this.headline,
    required this.detail,
  });

  final String assetPath;
  final String headline;
  final String detail;
}
