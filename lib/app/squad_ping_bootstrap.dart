import 'package:flutter/material.dart';

import '../features/signal_gate/screens/signal_gate_coordinator.dart';
import '../field_notes/repositories/pulse_story_repository.dart';
import 'theme/squad_ping_theme.dart';

class SquadPingBootstrap extends StatelessWidget {
  const SquadPingBootstrap({super.key});

  @override
  Widget build(BuildContext context) {
    final storyArchive = PulseStoryRepository.seeded();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SquadPing',
      theme: buildSquadPingTheme(),
      home: SignalGateCoordinator(storyArchive: storyArchive),
    );
  }
}
