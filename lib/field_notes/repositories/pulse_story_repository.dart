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
          pulseCode: 'Ramen circle',
          roomTone: '3 warm replies',
          openLoopLine:
              'Mika can hold a corner table if the group lands before 7.',
          replyCadenceLabel: '12 min average reply',
          readinessPercent: 78,
          lastSignalStamp: 'Updated 4:18 PM',
          microAgenda: ['seat count', 'walk timing', 'menu pick'],
          laneTint: SquadColorToken.grove,
        ),
        CrewPulseBrief(
          pulseCode: 'Court lights',
          roomTone: '2 maybes moving',
          openLoopLine:
              'Noel checked the east court; dry surface and open nets.',
          replyCadenceLabel: '18 min average reply',
          readinessPercent: 64,
          lastSignalStamp: 'Updated 3:52 PM',
          microAgenda: ['gear split', 'ride share', 'finish time'],
          laneTint: SquadColorToken.tidepool,
        ),
        CrewPulseBrief(
          pulseCode: 'Sunday board run',
          roomTone: 'quiet but steady',
          openLoopLine:
              'Leila has the table reserved and wants one backup host.',
          replyCadenceLabel: '31 min average reply',
          readinessPercent: 52,
          lastSignalStamp: 'Updated 2:36 PM',
          microAgenda: ['host backup', 'snack lane', 'game stack'],
          laneTint: SquadColorToken.marigold,
        ),
      ],
      rallyWindows: [
        RallyWindowDigest(
          rallyShortcode: 'Fri 6:50 PM',
          anchoredAround: 'Nori House, back room',
          hostCallout: 'Mika is anchoring the first check-in.',
          timeboxLabel: 'reply lock at 5:45',
          settlementCue: 'Need two firm yeses before reservation changes.',
          headcountTrace: '5 likely / 2 soft holds',
          decisionPressure: 0.74,
          commitmentLines: [
            'Arjun rides with Iris',
            'Talia arrives after 7:10',
          ],
          laneTint: SquadColorToken.ember,
        ),
        RallyWindowDigest(
          rallyShortcode: 'Sat 10:40 AM',
          anchoredAround: 'Cedar loop trailhead',
          hostCallout: 'Ren will post parking notes after breakfast.',
          timeboxLabel: 'weather check at 8:30',
          settlementCue: 'Keep it short if the forecast turns windy.',
          headcountTrace: '4 likely / 1 watching',
          decisionPressure: 0.58,
          commitmentLines: [
            'Noel brings spare bottle',
            'Mina has the route pin',
          ],
          laneTint: SquadColorToken.grove,
        ),
        RallyWindowDigest(
          rallyShortcode: 'Sun 3:00 PM',
          anchoredAround: 'Table 14 at Common Room',
          hostCallout: 'Leila can host if one more person confirms.',
          timeboxLabel: 'snack split by noon',
          settlementCue: 'Choose a lighter game if the group stays under four.',
          headcountTrace: '3 firm / 2 pending',
          decisionPressure: 0.49,
          commitmentLines: [
            'Iris brings score pads',
            'Bo has the short game list',
          ],
          laneTint: SquadColorToken.marigold,
        ),
      ],
      squadSignals: [
        TeammateSignalNote(
          signalId: 'mika-corner-host',
          displayCallsign: 'Mika Jo',
          currentDriftLine: 'Already nearby and ready to hold a spot.',
          responseTempo: 'fast in late afternoons',
          nearbyAnchor: 'Nori House block',
          trustRibbon: 'reliable closer',
          lastReplyAge: '6 min ago',
          checkInTrail: ['seat count', 'table photo', 'arrival note'],
          readinessScore: 92,
          preferredNudge: 'short direct ping',
          laneTint: SquadColorToken.grove,
        ),
        TeammateSignalNote(
          signalId: 'talia-after-work',
          displayCallsign: 'Talia Ren',
          currentDriftLine:
              'Free after a calendar wrap; prefers a clear cutoff.',
          responseTempo: 'checks twice before commute',
          nearbyAnchor: 'Market stop',
          trustRibbon: 'timing honest',
          lastReplyAge: '22 min ago',
          checkInTrail: ['commute gap', 'menu vote'],
          readinessScore: 76,
          preferredNudge: 'give a reply window',
          laneTint: SquadColorToken.ember,
        ),
        TeammateSignalNote(
          signalId: 'arjun-ride-link',
          displayCallsign: 'Arjun Pike',
          currentDriftLine: 'Can drive if the route stays simple.',
          responseTempo: 'best with a single yes/no ask',
          nearbyAnchor: 'North garage',
          trustRibbon: 'ride bridge',
          lastReplyAge: '34 min ago',
          checkInTrail: ['pickup order', 'parking ask'],
          readinessScore: 68,
          preferredNudge: 'one-tap confirm',
          laneTint: SquadColorToken.tidepool,
        ),
        TeammateSignalNote(
          signalId: 'iris-route-keeper',
          displayCallsign: 'Iris Vale',
          currentDriftLine: 'Watching timing and backup routes.',
          responseTempo: 'steady when plans are specific',
          nearbyAnchor: 'Library steps',
          trustRibbon: 'detail keeper',
          lastReplyAge: '48 min ago',
          checkInTrail: ['route pin', 'snack split', 'backup table'],
          readinessScore: 71,
          preferredNudge: 'context first',
          laneTint: SquadColorToken.marigold,
        ),
      ],
      nudgeLanes: [
        NudgeLaneMarker(
          laneKey: 'soft-check',
          menuLabel: 'Soft check',
          sendTone: 'low pressure',
          audienceHint: 'best for maybes and quiet members',
          draftedLine:
              'Still good for the ramen window, or should we keep you as a soft hold?',
          cooldownPhrase: 'Leaves room for a clean no.',
          buttonCaption: 'Send soft check',
          laneTint: SquadColorToken.grove,
        ),
        NudgeLaneMarker(
          laneKey: 'lock-rally',
          menuLabel: 'Lock rally',
          sendTone: 'decision ready',
          audienceHint: 'best when a booking or table depends on headcount',
          draftedLine:
              'Can you lock your yes by 5:45 so Mika knows whether to adjust the table?',
          cooldownPhrase: 'Clear cutoff without sounding pushy.',
          buttonCaption: 'Send lock ping',
          laneTint: SquadColorToken.ember,
        ),
        NudgeLaneMarker(
          laneKey: 'route-handoff',
          menuLabel: 'Route handoff',
          sendTone: 'coordination',
          audienceHint: 'best for rides, meetup pins, or backup locations',
          draftedLine:
              'Can you drop your arrival path here so Arjun can set the pickup order?',
          cooldownPhrase: 'Turns scattered logistics into one thread.',
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
