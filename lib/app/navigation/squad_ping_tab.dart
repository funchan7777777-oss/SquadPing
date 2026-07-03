import 'package:flutter/material.dart';

enum SquadPingTab {
  pulseDeck(Icons.bolt_rounded, 'Pulse'),
  rosterLane(Icons.diversity_3_rounded, 'Roster'),
  nudgeStudio(Icons.near_me_rounded, 'Ping');

  const SquadPingTab(this.glyph, this.caption);

  final IconData glyph;
  final String caption;
}
