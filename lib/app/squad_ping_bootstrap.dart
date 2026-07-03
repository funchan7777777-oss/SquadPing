import 'package:flutter/material.dart';

import '../field_notes/repositories/pulse_story_repository.dart';
import 'navigation/squad_ping_shell.dart';
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
      home: SquadPingShell(storyArchive: storyArchive),
    );
  }
}
