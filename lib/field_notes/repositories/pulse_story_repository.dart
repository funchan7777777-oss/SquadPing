import '../../shared/markings/squad_color_token.dart';
import '../models/crew_pulse_brief.dart';
import '../models/nudge_lane_marker.dart';
import '../models/rally_window_digest.dart';
import '../models/teammate_signal_note.dart';

class PulseStoryRepository {
  const PulseStoryRepository({
    required this.crewPulses,
    required this.rallyWindows,
    required this.squadSignals,
    required this.nudgeLanes,
  });

  factory PulseStoryRepository.seeded() {
    return const PulseStoryRepository(
      crewPulses: [
        CrewPulseBrief(
          pulseCode: 'Ranked trio',
          roomTone: '3 ready pings',
          openLoopLine:
              'Mika can hold the lobby if the squad locks roles before 7.',
          replyCadenceLabel: '12 min average reply',
          readinessPercent: 78,
          lastSignalStamp: 'Updated 4:18 PM',
          microAgenda: ['role lock', 'warmup map', 'queue window'],
          laneTint: SquadColorToken.grove,
        ),
        CrewPulseBrief(
          pulseCode: 'Co-op route',
          roomTone: '2 maybes moving',
          openLoopLine:
              'Noel checked the route board; one support slot is still open.',
          replyCadenceLabel: '18 min average reply',
          readinessPercent: 64,
          lastSignalStamp: 'Updated 3:52 PM',
          microAgenda: ['support slot', 'checkpoint order', 'finish time'],
          laneTint: SquadColorToken.tidepool,
        ),
        CrewPulseBrief(
          pulseCode: 'Arcade night',
          roomTone: 'quiet but steady',
          openLoopLine:
              'Leila has the casual room ready and wants one backup host.',
          replyCadenceLabel: '31 min average reply',
          readinessPercent: 52,
          lastSignalStamp: 'Updated 2:36 PM',
          microAgenda: ['host backup', 'score lane', 'game stack'],
          laneTint: SquadColorToken.marigold,
        ),
      ],
      rallyWindows: [
        RallyWindowDigest(
          rallyShortcode: 'Fri 6:50 PM',
          anchoredAround: 'Ranked lobby, voice room',
          hostCallout: 'Mika is anchoring the first lobby check.',
          timeboxLabel: 'role lock at 5:45',
          settlementCue: 'Need two firm yeses before queue plans change.',
          headcountTrace: '5 likely / 2 soft holds',
          decisionPressure: 0.74,
          commitmentLines: ['Arjun queues with Iris', 'Talia joins after 7:10'],
          laneTint: SquadColorToken.ember,
        ),
        RallyWindowDigest(
          rallyShortcode: 'Sat 10:40 AM',
          anchoredAround: 'Co-op route board',
          hostCallout: 'Ren will post checkpoint notes after warmup.',
          timeboxLabel: 'route check at 8:30',
          settlementCue: 'Keep it short if the squad needs an easier route.',
          headcountTrace: '4 likely / 1 watching',
          decisionPressure: 0.58,
          commitmentLines: ['Noel covers support', 'Mina has the route ping'],
          laneTint: SquadColorToken.grove,
        ),
        RallyWindowDigest(
          rallyShortcode: 'Sun 3:00 PM',
          anchoredAround: 'Arcade voice room',
          hostCallout: 'Leila can host if one more person confirms.',
          timeboxLabel: 'score lane by noon',
          settlementCue: 'Choose a lighter game if the group stays under four.',
          headcountTrace: '3 firm / 2 pending',
          decisionPressure: 0.49,
          commitmentLines: [
            'Iris tracks score lanes',
            'Bo has the short game list',
          ],
          laneTint: SquadColorToken.marigold,
        ),
      ],
      squadSignals: [
        TeammateSignalNote(
          signalId: 'mika-corner-host',
          displayCallsign: 'Mika Jo',
          currentDriftLine: 'Already online and ready to hold a lobby spot.',
          responseTempo: 'fast in late afternoons',
          nearbyAnchor: 'Ranked voice room',
          trustRibbon: 'reliable closer',
          lastReplyAge: '6 min ago',
          checkInTrail: ['role lock', 'lobby note', 'arrival ping'],
          readinessScore: 92,
          preferredNudge: 'short direct ping',
          laneTint: SquadColorToken.grove,
        ),
        TeammateSignalNote(
          signalId: 'talia-cooldown-window',
          displayCallsign: 'Talia Ren',
          currentDriftLine:
              'Free after a short cooldown; prefers a clear cutoff.',
          responseTempo: 'checks twice before queue',
          nearbyAnchor: 'Warmup room',
          trustRibbon: 'timing honest',
          lastReplyAge: '22 min ago',
          checkInTrail: ['cooldown gap', 'mode vote'],
          readinessScore: 76,
          preferredNudge: 'give a reply window',
          laneTint: SquadColorToken.ember,
        ),
        TeammateSignalNote(
          signalId: 'arjun-role-link',
          displayCallsign: 'Arjun Pike',
          currentDriftLine: 'Can anchor support if the route stays simple.',
          responseTempo: 'best with a single yes/no ask',
          nearbyAnchor: 'Support lane',
          trustRibbon: 'role bridge',
          lastReplyAge: '34 min ago',
          checkInTrail: ['role order', 'route ask'],
          readinessScore: 68,
          preferredNudge: 'one-tap confirm',
          laneTint: SquadColorToken.tidepool,
        ),
        TeammateSignalNote(
          signalId: 'iris-route-keeper',
          displayCallsign: 'Iris Vale',
          currentDriftLine: 'Watching timing and backup routes.',
          responseTempo: 'steady when plans are specific',
          nearbyAnchor: 'Map notes',
          trustRibbon: 'detail keeper',
          lastReplyAge: '48 min ago',
          checkInTrail: ['route ping', 'score split', 'backup lobby'],
          readinessScore: 71,
          preferredNudge: 'context first',
          laneTint: SquadColorToken.marigold,
        ),
      ],
      nudgeLanes: [
        NudgeLaneMarker(
          laneKey: 'soft-check',
          menuLabel: 'Soft queue check',
          sendTone: 'low pressure',
          audienceHint: 'best for maybes and quiet squadmates',
          draftedLine:
              'Still good for the squad queue window, or should we keep you as a soft hold?',
          cooldownPhrase: 'Leaves room for a clean no.',
          buttonCaption: 'Send soft check',
          laneTint: SquadColorToken.grove,
        ),
        NudgeLaneMarker(
          laneKey: 'lock-rally',
          menuLabel: 'Lock squad',
          sendTone: 'decision ready',
          audienceHint: 'best when a queue plan depends on headcount',
          draftedLine:
              'Can you lock your yes by 5:45 so Mika knows whether to adjust the squad plan?',
          cooldownPhrase: 'Clear cutoff without sounding pushy.',
          buttonCaption: 'Send lock ping',
          laneTint: SquadColorToken.ember,
        ),
        NudgeLaneMarker(
          laneKey: 'route-handoff',
          menuLabel: 'Route handoff',
          sendTone: 'coordination',
          audienceHint: 'best for route pings, role swaps, or backup lobbies',
          draftedLine:
              'Can you drop your route plan here so Arjun can set the role order?',
          cooldownPhrase: 'Turns scattered squad logistics into one thread.',
          buttonCaption: 'Send route ping',
          laneTint: SquadColorToken.tidepool,
        ),
      ],
    );
  }

  final List<CrewPulseBrief> crewPulses;
  final List<RallyWindowDigest> rallyWindows;
  final List<TeammateSignalNote> squadSignals;
  final List<NudgeLaneMarker> nudgeLanes;
}
