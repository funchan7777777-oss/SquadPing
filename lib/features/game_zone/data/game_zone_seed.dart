import '../../../shared/visuals/squad_ping_assets.dart';
import '../models/game_zone_models.dart';

abstract final class GameZoneSeed {
  static const viewer = PlayerProfile(
    id: 'viewer-esme',
    displayName: 'Esme Ping',
    age: 20,
    country: 'USA',
    gender: PlayerGender.female,
    avatarAsset: SquadPingAssets.avatarFemaleNeonCat,
    playStyle: 'Fast party finder',
  );

  static const victoria = PlayerProfile(
    id: 'victoria',
    displayName: 'Vika IGL',
    age: 21,
    country: 'Canada',
    gender: PlayerGender.female,
    avatarAsset: SquadPingAssets.avatarFemalePinkHeadset,
    playStyle: 'Ranked caller',
  );
  static const luna = PlayerProfile(
    id: 'luna',
    displayName: 'Luna Build',
    age: 19,
    country: 'USA',
    gender: PlayerGender.female,
    avatarAsset: SquadPingAssets.avatarFemaleBlondeHeadset,
    playStyle: 'Creative builder',
  );
  static const aria = PlayerProfile(
    id: 'aria',
    displayName: 'Aria Lore',
    age: 22,
    country: 'UK',
    gender: PlayerGender.female,
    avatarAsset: SquadPingAssets.avatarFemaleSunlitSelfie,
    playStyle: 'Lore hunter',
  );
  static const maya = PlayerProfile(
    id: 'maya',
    displayName: 'Maya Co-op',
    age: 23,
    country: 'Australia',
    gender: PlayerGender.female,
    avatarAsset: SquadPingAssets.avatarFemaleWhiteHeadset,
    playStyle: 'Co-op anchor',
  );
  static const ivy = PlayerProfile(
    id: 'ivy',
    displayName: 'Ivy Guard',
    age: 20,
    country: 'Germany',
    gender: PlayerGender.female,
    avatarAsset: SquadPingAssets.avatarFemaleGlassesSoft,
    playStyle: 'Support main',
  );
  static const nia = PlayerProfile(
    id: 'nia',
    displayName: 'Nia Queue',
    age: 21,
    country: 'France',
    gender: PlayerGender.female,
    avatarAsset: SquadPingAssets.avatarFemaleGrayHeadphones,
    playStyle: 'Late-night grinder',
  );
  static const kira = PlayerProfile(
    id: 'kira',
    displayName: 'Kira Aim',
    age: 24,
    country: 'Sweden',
    gender: PlayerGender.female,
    avatarAsset: SquadPingAssets.avatarFemaleCompetitiveHeadset,
    playStyle: 'Duel specialist',
  );
  static const zoe = PlayerProfile(
    id: 'zoe',
    displayName: 'Zoe Notes',
    age: 22,
    country: 'Italy',
    gender: PlayerGender.female,
    avatarAsset: SquadPingAssets.avatarFemaleGlassesLeopard,
    playStyle: 'Strategy note taker',
  );
  static const rina = PlayerProfile(
    id: 'rina',
    displayName: 'Rina Stream',
    age: 20,
    country: 'Japan',
    gender: PlayerGender.female,
    avatarAsset: SquadPingAssets.avatarFemalePinkGamer,
    playStyle: 'Streamer stack',
  );
  static const hana = PlayerProfile(
    id: 'hana',
    displayName: 'Hana Aim',
    age: 25,
    country: 'Korea',
    gender: PlayerGender.female,
    avatarAsset: SquadPingAssets.avatarFemaleNeckHeadphones,
    playStyle: 'Aim trainer',
  );
  static const mia = PlayerProfile(
    id: 'mia',
    displayName: 'Mia Lead',
    age: 23,
    country: 'Spain',
    gender: PlayerGender.female,
    avatarAsset: SquadPingAssets.avatarFemaleWhiteSleeveless,
    playStyle: 'Queue captain',
  );
  static const axel = PlayerProfile(
    id: 'axel',
    displayName: 'Axel Arcade',
    age: 24,
    country: 'USA',
    gender: PlayerGender.male,
    avatarAsset: SquadPingAssets.avatarMaleArcadeHost,
    playStyle: 'Arcade collector',
  );
  static const leo = PlayerProfile(
    id: 'leo',
    displayName: 'Leo Entry',
    age: 20,
    country: 'Brazil',
    gender: PlayerGender.male,
    avatarAsset: SquadPingAssets.avatarMaleStreetSnap,
    playStyle: 'Aggressive entry',
  );
  static const kai = PlayerProfile(
    id: 'kai',
    displayName: 'Kai Calls',
    age: 22,
    country: 'Canada',
    gender: PlayerGender.male,
    avatarAsset: SquadPingAssets.avatarMaleBlueRoom,
    playStyle: 'Shot caller',
  );
  static const nate = PlayerProfile(
    id: 'nate',
    displayName: 'Nate Pad',
    age: 21,
    country: 'UK',
    gender: PlayerGender.male,
    avatarAsset: SquadPingAssets.avatarMaleMaroonHeadset,
    playStyle: 'Console flex',
  );
  static const owen = PlayerProfile(
    id: 'owen',
    displayName: 'Owen Route',
    age: 25,
    country: 'Germany',
    gender: PlayerGender.male,
    avatarAsset: SquadPingAssets.avatarMaleLoungePlayer,
    playStyle: 'Puzzle routes',
  );
  static const finn = PlayerProfile(
    id: 'finn',
    displayName: 'Finn Scout',
    age: 23,
    country: 'Ireland',
    gender: PlayerGender.male,
    avatarAsset: SquadPingAssets.avatarMaleShadowProfile,
    playStyle: 'Stealth planner',
  );
  static const marco = PlayerProfile(
    id: 'marco',
    displayName: 'Marco Hold',
    age: 26,
    country: 'Mexico',
    gender: PlayerGender.male,
    avatarAsset: SquadPingAssets.avatarMaleGlassesHeadset,
    playStyle: 'Clutch support',
  );
  static const theo = PlayerProfile(
    id: 'theo',
    displayName: 'Theo Map',
    age: 24,
    country: 'Portugal',
    gender: PlayerGender.male,
    avatarAsset: SquadPingAssets.avatarMaleDaylightPlayer,
    playStyle: 'Open-world scout',
  );
  static const jax = PlayerProfile(
    id: 'jax',
    displayName: 'Jax Pad',
    age: 19,
    country: 'USA',
    gender: PlayerGender.male,
    avatarAsset: SquadPingAssets.avatarMaleConsoleDen,
    playStyle: 'Controller learner',
  );
  static const amir = PlayerProfile(
    id: 'amir',
    displayName: 'Amir Host',
    age: 22,
    country: 'UAE',
    gender: PlayerGender.male,
    avatarAsset: SquadPingAssets.avatarMaleSmilingController,
    playStyle: 'Party host',
  );
  static const cole = PlayerProfile(
    id: 'cole',
    displayName: 'Cole Duo',
    age: 23,
    country: 'Australia',
    gender: PlayerGender.male,
    avatarAsset: SquadPingAssets.avatarMaleFocusController,
    playStyle: 'Tactical duo',
  );
  static const rex = PlayerProfile(
    id: 'rex',
    displayName: 'Rex Replay',
    age: 21,
    country: 'USA',
    gender: PlayerGender.male,
    avatarAsset: SquadPingAssets.avatarMaleBacklitStation,
    playStyle: 'Spectator analyst',
  );

  static const players = <PlayerProfile>[
    viewer,
    victoria,
    luna,
    aria,
    maya,
    ivy,
    nia,
    kira,
    zoe,
    rina,
    hana,
    mia,
    axel,
    leo,
    kai,
    nate,
    owen,
    finn,
    marco,
    theo,
    jax,
    amir,
    cole,
    rex,
  ];

  static const games = <GameTitle>[
    GameTitle(
      id: 'fortnite',
      name: 'Fortnite',
      coverAsset: SquadPingAssets.gameFortressCover,
      rating: 4.9,
      summary: 'Colorful island drops, fast loot routes, and build fights.',
      detail:
          'Fortnite sends squads onto a bright fantasy island to loot, rotate, and survive closing storm circles. Players can build walls and ramps for cover, or switch to Zero Build for cleaner aim duels. Creative maps are useful for warmups, parkour practice, and custom party modes.',
      tags: ['Battle royale', 'Creative', 'Squads'],
      hotLevel: 5,
      comments: [
        GameComment(
          author: victoria,
          message:
              'Zero Build squads feel sharp tonight. I can mark rotations if someone tracks storm tags.',
          postedAt: 'Jul 6 14:36',
        ),
        GameComment(
          author: luna,
          message:
              'Creative aim maps are still my best warmup before ranked. Send island codes if you have good ones.',
          postedAt: 'Jul 6 13:58',
        ),
        GameComment(
          author: axel,
          message:
              'The loot pool finally rewards late-game high ground without making every end circle messy.',
          postedAt: 'Jul 5 22:10',
        ),
        GameComment(
          author: mia,
          message:
              'I am practicing quick wall edits. Happy to run duos with patient builders.',
          postedAt: 'Jul 5 20:42',
        ),
      ],
    ),
    GameTitle(
      id: 'counter-strike-2',
      name: 'Counter-strike 2',
      coverAsset: SquadPingAssets.gameStrikeCover,
      rating: 4.8,
      summary: 'Objective sites, utility lineups, and clutch retakes.',
      detail:
          'Counter-strike 2 is built around disciplined five-player rounds. Teams hold angles, coordinate smoke and flash lineups, manage the economy, and trade around objective sites. The best squads keep voice calls short so every peek and retake stays clean.',
      tags: ['FPS', 'Ranked', 'Tactics'],
      hotLevel: 5,
      comments: [
        GameComment(
          author: kira,
          message:
              'Looking for people who know Mirage utility and keep mid-round calls short.',
          postedAt: 'Jul 6 12:44',
        ),
        GameComment(
          author: marco,
          message:
              'I can anchor B sites. Need one entry and one calm IGL for Premier.',
          postedAt: 'Jul 5 23:16',
        ),
        GameComment(
          author: cole,
          message:
              'Save calls matter. Random teams keep forcing rifles when the economy is broken.',
          postedAt: 'Jul 5 18:25',
        ),
      ],
    ),
    GameTitle(
      id: 'clash-of-clans',
      name: 'Clash of Clans (COC)',
      coverAsset: SquadPingAssets.gameKingdomCover,
      rating: 4.7,
      summary: 'Village raids, troop pathing, and clan war base planning.',
      detail:
          'Clash of Clans turns village building into a clan strategy game. Players upgrade defenses, scout enemy bases, plan troop funnels, and coordinate spells before war attacks. Strong clans review layouts together instead of rushing targets.',
      tags: ['Strategy', 'Clan war', 'Base design'],
      hotLevel: 4,
      comments: [
        GameComment(
          author: zoe,
          message:
              'Post anti-three-star bases. I want to test hybrid and lalo routes before war day.',
          postedAt: 'Jul 6 10:22',
        ),
        GameComment(
          author: owen,
          message:
              'War prep has to start earlier. Last-minute donations keep breaking our attack plans.',
          postedAt: 'Jul 4 21:34',
        ),
      ],
    ),
    GameTitle(
      id: 'shadow-ops',
      name: 'Shadow Ops',
      coverAsset: SquadPingAssets.gameOpsCover,
      rating: 4.6,
      summary: 'Dark tactical pushes, extraction windows, and squad roles.',
      detail:
          'Shadow Ops is for players who like tense tactical fights in hostile zones. Squads push through smoke, grab high-value gear, and decide when to extract before the map collapses. A balanced team needs an entry, a scout, and one calm timer caller.',
      tags: ['Extraction', 'Fireteam', 'Loot'],
      hotLevel: 4,
      comments: [
        GameComment(
          author: amir,
          message:
              'Bring smoke cover for extraction. Losing full bags at the gate is the worst part of this mode.',
          postedAt: 'Jul 5 19:48',
        ),
      ],
    ),
    GameTitle(
      id: 'spectator-legends',
      name: 'Spectator Legends',
      coverAsset: SquadPingAssets.gameSpectatorCover,
      rating: 4.5,
      summary: 'Hero highlights, match watch parties, and meta breakdowns.',
      detail:
          'Spectator Legends is a watch-party space for players who follow hero picks, cinematic plays, and patch trends. It fits fans who want to review highlights, compare draft choices, and talk meta without flooding active game rooms.',
      tags: ['Watch party', 'Drafts', 'Meta'],
      hotLevel: 3,
      comments: [
        GameComment(
          author: rex,
          message:
              'The finals draft review was sharp. We need a separate thread for support picks.',
          postedAt: 'Jul 6 09:12',
        ),
        GameComment(
          author: theo,
          message:
              'Please tag spoilers for people watching replays later tonight.',
          postedAt: 'Jul 5 23:40',
        ),
        GameComment(
          author: hana,
          message:
              'That second-map rotation looked simple, but it changed every objective fight.',
          postedAt: 'Jul 5 22:05',
        ),
        GameComment(
          author: nia,
          message:
              'Patch notes made the caster desk way more interesting this week.',
          postedAt: 'Jul 4 20:18',
        ),
        GameComment(
          author: kai,
          message:
              'I am saving the VOD for draft practice. Hero bans were cleaner than usual.',
          postedAt: 'Jul 3 18:55',
        ),
      ],
    ),
    GameTitle(
      id: 'kingdom-rivals',
      name: 'Kingdom Rivals',
      coverAsset: SquadPingAssets.gameKingCover,
      rating: 4.4,
      summary: 'Royal arena battles with hero timing and lane control.',
      detail:
          'Kingdom Rivals focuses on fantasy arena pushes where teams protect their ruler, pressure lanes, and time hero skills before the final clash. Strong parties call rotations early, save crowd control for enemy carries, and turn small skirmishes into throne pushes.',
      tags: ['Fantasy', 'Arena', 'Teamfight'],
      hotLevel: 3,
      comments: [
        GameComment(
          author: aria,
          message:
              'The king defense phase is much easier when one player saves stun for flankers.',
          postedAt: 'Jul 6 08:50',
        ),
        GameComment(
          author: nate,
          message:
              'I can play front line if someone handles lane calls and objective timers.',
          postedAt: 'Jul 5 21:27',
        ),
        GameComment(
          author: ivy,
          message:
              'Do not chase after the first tower. Reset, buy, then push throne together.',
          postedAt: 'Jul 5 17:36',
        ),
        GameComment(
          author: finn,
          message:
              'Side lane pressure wins more matches than raw damage in this one.',
          postedAt: 'Jul 4 22:11',
        ),
        GameComment(
          author: rina,
          message:
              'The mage burst window is short, but it deletes the royal guard if timed right.',
          postedAt: 'Jul 4 16:09',
        ),
        GameComment(
          author: jax,
          message:
              'I am still learning guard swaps. A slower party would help.',
          postedAt: 'Jul 3 19:44',
        ),
      ],
    ),
  ];

  static const rooms = <ChatRoom>[
    ChatRoom(
      id: 'world-gamer-chat-hub',
      name: 'World-Gamer Chat Hub',
      coverAsset: SquadPingAssets.chatOpenWorld,
      summary: 'Drop your game, role, and queue window.',
      welcomeLine: 'Drop your game, role, and queue window.',
      topic: 'Open-world plans, party finding, and light game talk.',
      memberCount: 128,
      participants: [viewer, luna, aria, axel],
      messages: [
        ChatMessage(
          author: victoria,
          message: 'Anyone queueing after daily reset?',
          sentAt: '14:08',
        ),
        ChatMessage(
          author: luna,
          message: 'I am warming up in Creative. Need ten minutes.',
          sentAt: '14:10',
        ),
        ChatMessage(
          author: aria,
          message: 'Fortnite first, then maybe a chill exploration run after.',
          sentAt: '14:12',
        ),
        ChatMessage(
          author: axel,
          message: 'I can host the party after my daily arcade clear.',
          sentAt: '14:13',
        ),
        ChatMessage(
          author: aria,
          message: 'Mark roles before we drop. Last squad got split too fast.',
          sentAt: '14:16',
        ),
        ChatMessage(
          author: victoria,
          message: 'Good call. I can scout and keep storm route notes.',
          sentAt: '14:18',
        ),
        ChatMessage(
          author: luna,
          message: 'I have two warmup islands ready if anyone wants codes.',
          sentAt: '14:21',
        ),
        ChatMessage(
          author: victoria,
          message: 'Send them here. We can keep the cleaner one for tonight.',
          sentAt: '14:23',
        ),
        ChatMessage(
          author: axel,
          message: 'Party opens at :30. Bring mics or fast pings.',
          sentAt: '14:27',
        ),
      ],
    ),
    ChatRoom(
      id: 'game-discussion',
      name: 'Game Discussion',
      coverAsset: SquadPingAssets.chatStreamerStation,
      summary: 'Controller setups, platform notes, and squad-ready settings.',
      welcomeLine: 'Drop your build, role, and platform before queueing.',
      topic: 'Console, PC, and controller-friendly game setup talk.',
      memberCount: 76,
      participants: [victoria, kai, nate, maya],
      messages: [
        ChatMessage(
          author: nate,
          message: 'Controller players, what sensitivity are you using now?',
          sentAt: '13:02',
        ),
        ChatMessage(
          author: kai,
          message: 'Anyone using gyro controls for shooters?',
          sentAt: '13:05',
        ),
        ChatMessage(
          author: maya,
          message: 'For co-op games, I still prefer controller plus headset.',
          sentAt: '13:07',
        ),
        ChatMessage(
          author: victoria,
          message: 'Gyro is great for tiny corrections, not full turns.',
          sentAt: '13:11',
        ),
        ChatMessage(
          author: nate,
          message: 'That makes sense. I keep overaiming in close fights.',
          sentAt: '13:14',
        ),
        ChatMessage(
          author: kai,
          message: 'Try lower stick speed and let gyro finish the adjustment.',
          sentAt: '13:18',
        ),
      ],
    ),
    ChatRoom(
      id: 'battle-chat-room',
      name: 'Aim Tactics Room',
      coverAsset: SquadPingAssets.chatCardKeys,
      summary: 'Exchange aim plans, loadout notes, and match tactics.',
      welcomeLine: 'Keep calls short: role, route, danger, reset.',
      topic: 'FPS tactics, loadouts, and clean team communication.',
      memberCount: 93,
      participants: [ivy, marco, cole, rina],
      messages: [
        ChatMessage(
          author: ivy,
          message: 'Can we keep callouts to role, route, danger, reset?',
          sentAt: '12:36',
        ),
        ChatMessage(
          author: marco,
          message: 'Two players hold crossfire, one watches flank.',
          sentAt: '12:38',
        ),
        ChatMessage(
          author: cole,
          message: 'I can take flank watch if someone trades my first contact.',
          sentAt: '12:40',
        ),
        ChatMessage(
          author: rina,
          message: 'Save utility for the final thirty seconds.',
          sentAt: '12:43',
        ),
        ChatMessage(
          author: marco,
          message: 'Perfect. No long speeches mid-round.',
          sentAt: '12:45',
        ),
      ],
    ),
    ChatRoom(
      id: 'arcade-lobby',
      name: 'Arcade Lobby',
      coverAsset: SquadPingAssets.chatArcadeLobby,
      summary: 'Quick runs, retro scores, and casual party invites.',
      welcomeLine: 'Pick a cabinet, post your score, invite a rival.',
      topic: 'Arcade runs, score challenges, and casual events.',
      memberCount: 54,
      participants: [jax, amir, nia, zoe],
      messages: [
        ChatMessage(
          author: amir,
          message: 'Beat my rhythm score and I will host the next lobby.',
          sentAt: '12:00',
        ),
        ChatMessage(
          author: nia,
          message: 'Late-night arcade queue sounds perfect.',
          sentAt: '12:02',
        ),
        ChatMessage(
          author: jax,
          message: 'I am rusty, but I can bring the racing cabinet route.',
          sentAt: '12:04',
        ),
        ChatMessage(
          author: zoe,
          message: 'Post screenshots. Scores without proof do not count.',
          sentAt: '12:06',
        ),
        ChatMessage(
          author: amir,
          message: "Deal. Winner picks tomorrow's casual room.",
          sentAt: '12:08',
        ),
      ],
    ),
    ChatRoom(
      id: 'strategy-table',
      name: 'Strategy Table',
      coverAsset: SquadPingAssets.chatStrategyTable,
      summary: 'Turn order, card reads, and tabletop-style planning.',
      welcomeLine: 'Share the plan before the timer starts.',
      topic: 'Strategy rooms for players who like calm planning.',
      memberCount: 41,
      participants: [owen, finn, kira, mia],
      messages: [
        ChatMessage(
          author: owen,
          message: 'I mapped two safer routes for tonight.',
          sentAt: '13:15',
        ),
        ChatMessage(
          author: kira,
          message: 'Send the board state before we lock roles.',
          sentAt: '13:17',
        ),
        ChatMessage(
          author: finn,
          message: 'Top path looks slower, but it avoids the early trap.',
          sentAt: '13:19',
        ),
        ChatMessage(
          author: mia,
          message: 'I can take resource tracking if someone handles timers.',
          sentAt: '13:22',
        ),
        ChatMessage(
          author: owen,
          message: 'Good. I will upload the revised route after scrim break.',
          sentAt: '13:25',
        ),
      ],
    ),
    ChatRoom(
      id: 'esports-watch',
      name: 'Esports Watch',
      coverAsset: SquadPingAssets.chatEsportsArena,
      summary: 'Live match reactions and post-game breakdowns.',
      welcomeLine: 'No spoilers without a warning. Keep analysis readable.',
      topic: 'Watch parties, bracket talk, and pro match reviews.',
      memberCount: 112,
      participants: [hana, theo, rex, leo],
      messages: [
        ChatMessage(
          author: leo,
          message: 'Finals replay starts in fifteen. Spoilers off?',
          sentAt: '15:31',
        ),
        ChatMessage(
          author: rex,
          message: 'The second map draft changed the whole series.',
          sentAt: '15:40',
        ),
        ChatMessage(
          author: hana,
          message: 'Aim duels were clean, but rotations won the match.',
          sentAt: '15:44',
        ),
        ChatMessage(
          author: theo,
          message: 'Watch the support pathing before the third objective.',
          sentAt: '15:48',
        ),
        ChatMessage(
          author: rex,
          message: 'Agreed. That rotation forced every late fight.',
          sentAt: '15:52',
        ),
      ],
    ),
  ];
}
