import '../../../shared/visuals/squad_ping_assets.dart';
import '../models/game_zone_models.dart';

abstract final class GameZoneSeed {
  static const viewer = PlayerProfile(
    id: 'viewer-esme',
    displayName: 'Esme',
    age: 20,
    country: 'USA',
    gender: PlayerGender.female,
    avatarAsset: SquadPingAssets.avatarFemaleNeonCat,
    playStyle: 'Fast party finder',
  );

  static const victoria = PlayerProfile(
    id: 'victoria',
    displayName: 'Victoria',
    age: 21,
    country: 'Canada',
    gender: PlayerGender.female,
    avatarAsset: SquadPingAssets.avatarFemalePinkHeadset,
    playStyle: 'Ranked caller',
  );
  static const luna = PlayerProfile(
    id: 'luna',
    displayName: 'Luna',
    age: 19,
    country: 'USA',
    gender: PlayerGender.female,
    avatarAsset: SquadPingAssets.avatarFemaleBlondeHeadset,
    playStyle: 'Creative builder',
  );
  static const aria = PlayerProfile(
    id: 'aria',
    displayName: 'Aria',
    age: 22,
    country: 'UK',
    gender: PlayerGender.female,
    avatarAsset: SquadPingAssets.avatarFemaleSunlitSelfie,
    playStyle: 'Lore hunter',
  );
  static const maya = PlayerProfile(
    id: 'maya',
    displayName: 'Maya',
    age: 23,
    country: 'Australia',
    gender: PlayerGender.female,
    avatarAsset: SquadPingAssets.avatarFemaleWhiteHeadset,
    playStyle: 'Co-op anchor',
  );
  static const ivy = PlayerProfile(
    id: 'ivy',
    displayName: 'Ivy',
    age: 20,
    country: 'Germany',
    gender: PlayerGender.female,
    avatarAsset: SquadPingAssets.avatarFemaleGlassesSoft,
    playStyle: 'Support main',
  );
  static const nia = PlayerProfile(
    id: 'nia',
    displayName: 'Nia',
    age: 21,
    country: 'France',
    gender: PlayerGender.female,
    avatarAsset: SquadPingAssets.avatarFemaleGrayHeadphones,
    playStyle: 'Late-night grinder',
  );
  static const kira = PlayerProfile(
    id: 'kira',
    displayName: 'Kira',
    age: 24,
    country: 'Sweden',
    gender: PlayerGender.female,
    avatarAsset: SquadPingAssets.avatarFemaleCompetitiveHeadset,
    playStyle: 'Duel specialist',
  );
  static const zoe = PlayerProfile(
    id: 'zoe',
    displayName: 'Zoe',
    age: 22,
    country: 'Italy',
    gender: PlayerGender.female,
    avatarAsset: SquadPingAssets.avatarFemaleGlassesLeopard,
    playStyle: 'Strategy note taker',
  );
  static const rina = PlayerProfile(
    id: 'rina',
    displayName: 'Rina',
    age: 20,
    country: 'Japan',
    gender: PlayerGender.female,
    avatarAsset: SquadPingAssets.avatarFemalePinkGamer,
    playStyle: 'Streamer stack',
  );
  static const hana = PlayerProfile(
    id: 'hana',
    displayName: 'Hana',
    age: 25,
    country: 'Korea',
    gender: PlayerGender.female,
    avatarAsset: SquadPingAssets.avatarFemaleNeckHeadphones,
    playStyle: 'Aim trainer',
  );
  static const mia = PlayerProfile(
    id: 'mia',
    displayName: 'Mia',
    age: 23,
    country: 'Spain',
    gender: PlayerGender.female,
    avatarAsset: SquadPingAssets.avatarFemaleWhiteSleeveless,
    playStyle: 'Queue captain',
  );
  static const axel = PlayerProfile(
    id: 'axel',
    displayName: 'Axel',
    age: 24,
    country: 'USA',
    gender: PlayerGender.male,
    avatarAsset: SquadPingAssets.avatarMaleArcadeHost,
    playStyle: 'Arcade collector',
  );
  static const leo = PlayerProfile(
    id: 'leo',
    displayName: 'Leo',
    age: 20,
    country: 'Brazil',
    gender: PlayerGender.male,
    avatarAsset: SquadPingAssets.avatarMaleStreetSnap,
    playStyle: 'Aggressive entry',
  );
  static const kai = PlayerProfile(
    id: 'kai',
    displayName: 'Kai',
    age: 22,
    country: 'Canada',
    gender: PlayerGender.male,
    avatarAsset: SquadPingAssets.avatarMaleBlueRoom,
    playStyle: 'Shot caller',
  );
  static const nate = PlayerProfile(
    id: 'nate',
    displayName: 'Nate',
    age: 21,
    country: 'UK',
    gender: PlayerGender.male,
    avatarAsset: SquadPingAssets.avatarMaleMaroonHeadset,
    playStyle: 'Console flex',
  );
  static const owen = PlayerProfile(
    id: 'owen',
    displayName: 'Owen',
    age: 25,
    country: 'Germany',
    gender: PlayerGender.male,
    avatarAsset: SquadPingAssets.avatarMaleLoungePlayer,
    playStyle: 'Puzzle routes',
  );
  static const finn = PlayerProfile(
    id: 'finn',
    displayName: 'Finn',
    age: 23,
    country: 'Ireland',
    gender: PlayerGender.male,
    avatarAsset: SquadPingAssets.avatarMaleShadowProfile,
    playStyle: 'Stealth planner',
  );
  static const marco = PlayerProfile(
    id: 'marco',
    displayName: 'Marco',
    age: 26,
    country: 'Mexico',
    gender: PlayerGender.male,
    avatarAsset: SquadPingAssets.avatarMaleGlassesHeadset,
    playStyle: 'Clutch support',
  );
  static const theo = PlayerProfile(
    id: 'theo',
    displayName: 'Theo',
    age: 24,
    country: 'Portugal',
    gender: PlayerGender.male,
    avatarAsset: SquadPingAssets.avatarMaleDaylightPlayer,
    playStyle: 'Open-world scout',
  );
  static const jax = PlayerProfile(
    id: 'jax',
    displayName: 'Jax',
    age: 19,
    country: 'USA',
    gender: PlayerGender.male,
    avatarAsset: SquadPingAssets.avatarMaleConsoleDen,
    playStyle: 'Controller learner',
  );
  static const amir = PlayerProfile(
    id: 'amir',
    displayName: 'Amir',
    age: 22,
    country: 'UAE',
    gender: PlayerGender.male,
    avatarAsset: SquadPingAssets.avatarMaleSmilingController,
    playStyle: 'Party host',
  );
  static const cole = PlayerProfile(
    id: 'cole',
    displayName: 'Cole',
    age: 23,
    country: 'Australia',
    gender: PlayerGender.male,
    avatarAsset: SquadPingAssets.avatarMaleFocusController,
    playStyle: 'Tactical duo',
  );
  static const rex = PlayerProfile(
    id: 'rex',
    displayName: 'Rex',
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
      summary: 'Battle Royale Mode: 100 players parachute to the island.',
      detail:
          'Battle Royale Mode: 100 players parachute to the ground and collect weapons, shields, and medical supplies. A unique feature is the ability to build walls and stairs for cover. Creative Mode lets players build maps, practice routes, and host custom parties with friends.',
      tags: ['Battle royale', 'Creative', 'Squads'],
      hotLevel: 5,
      comments: [
        GameComment(
          author: viewer,
          message:
              'I want a duo for zero build tonight. Prefer clear pings and quick rotations.',
          postedAt: '2 min ago',
        ),
        GameComment(
          author: luna,
          message:
              'Creative maps are still the best warmup before ranked. Share your island codes.',
          postedAt: '8 min ago',
        ),
        GameComment(
          author: axel,
          message:
              'The current loot pool feels better for late-game fights than last week.',
          postedAt: '16 min ago',
        ),
      ],
    ),
    GameTitle(
      id: 'counter-strike-2',
      name: 'Counter-strike 2',
      coverAsset: SquadPingAssets.gameStrikeCover,
      rating: 4.9,
      summary: 'Tight economy rounds, clean comms, and precise aim checks.',
      detail:
          'Counter-strike 2 rewards practiced utility, map control, and short voice calls. Good squads agree on defaults, trade spacing, and save rules before the first pistol round.',
      tags: ['FPS', 'Ranked', 'Tactics'],
      hotLevel: 5,
      comments: [
        GameComment(
          author: kira,
          message:
              'Looking for people who know Mirage utility and do not overcall mid round.',
          postedAt: '11 min ago',
        ),
        GameComment(
          author: marco,
          message:
              'I can anchor B sites. Need one entry and one calm IGL for premier.',
          postedAt: '20 min ago',
        ),
      ],
    ),
    GameTitle(
      id: 'clash-of-clans',
      name: 'Clash of Clans (COC)',
      coverAsset: SquadPingAssets.gameKingdomCover,
      rating: 4.8,
      summary: 'Clan wars, base layouts, and troop pathing discussions.',
      detail:
          'Clash of Clans is strongest when the clan plans attacks together. Members can review base layouts, assign targets, and coordinate spell timing before the war clock gets tight.',
      tags: ['Strategy', 'Clan war', 'Base design'],
      hotLevel: 4,
      comments: [
        GameComment(
          author: zoe,
          message:
              'Post your anti-three-star bases. I want to test hybrid and lalo routes.',
          postedAt: '30 min ago',
        ),
        GameComment(
          author: owen,
          message:
              'War prep should start earlier. Last-minute donations are killing attacks.',
          postedAt: '42 min ago',
        ),
      ],
    ),
    GameTitle(
      id: 'shadow-ops',
      name: 'Shadow Ops',
      coverAsset: SquadPingAssets.gameOpsCover,
      rating: 4.7,
      summary: 'Heavy firefights with extraction timing and squad roles.',
      detail:
          'Shadow Ops focuses on high-pressure firefights, resource grabs, and extraction windows. A balanced team needs an entry player, a scout, and one person watching the exit timer.',
      tags: ['Extraction', 'Fireteam', 'Loot'],
      hotLevel: 4,
      comments: [
        GameComment(
          author: amir,
          message:
              'Bring smokes for every extraction. Randoms keep losing full bags at the gate.',
          postedAt: '1 hr ago',
        ),
        GameComment(
          author: leo,
          message:
              'I can entry if someone keeps the timer and backpack calls clean.',
          postedAt: '1 hr ago',
        ),
      ],
    ),
    GameTitle(
      id: 'spectator-legends',
      name: 'Spectator Legends',
      coverAsset: SquadPingAssets.gameSpectatorCover,
      rating: 4.6,
      summary: 'Watch-party analysis for meta shifts and pro match drafts.',
      detail:
          'Spectator Legends is a watch-party space for people who like reading drafts, rotations, and patch trends. It is built for fans who want match analysis without flooding active game rooms.',
      tags: ['Watch party', 'Drafts', 'Meta'],
      hotLevel: 3,
      comments: [
        GameComment(
          author: rex,
          message:
              'Draft review after finals was sharp. We need a thread for support picks.',
          postedAt: '2 hr ago',
        ),
        GameComment(
          author: theo,
          message:
              'Please tag spoilers for people watching later in different time zones.',
          postedAt: '2 hr ago',
        ),
      ],
    ),
  ];

  static const rooms = <ChatRoom>[
    ChatRoom(
      id: 'world-gamer-chat-hub',
      name: 'World-Gamer Chat Hub',
      coverAsset: SquadPingAssets.chatOpenWorld,
      summary: 'Welcome all game enthusiasts to join!',
      welcomeLine: 'Welcome all game enthusiasts to join!',
      topic: 'Open-world plans, party finding, and light game talk.',
      participants: [viewer, luna, aria, axel],
      messages: [
        ChatMessage(
          author: victoria,
          message: 'What games are you all playing? Share!',
          sentAt: '9:41',
        ),
        ChatMessage(
          author: viewer,
          message: 'Fortnite first, then maybe a chill exploration run.',
          sentAt: '9:42',
        ),
        ChatMessage(
          author: axel,
          message: 'I can host the party after my daily arcade clear.',
          sentAt: '9:43',
        ),
      ],
    ),
    ChatRoom(
      id: 'game-discussion',
      name: 'Game Discussion',
      coverAsset: SquadPingAssets.chatStreamerStation,
      summary: 'Console gamer. Discussing various gameplay styles.',
      welcomeLine: 'Drop your build, role, and platform before queueing.',
      topic: 'Console, PC, and controller-friendly game setup talk.',
      participants: [victoria, kai, nate, maya],
      messages: [
        ChatMessage(
          author: kai,
          message: 'Anyone using gyro controls for shooters?',
          sentAt: '10:05',
        ),
        ChatMessage(
          author: maya,
          message: 'For co-op games, I still prefer controller plus headset.',
          sentAt: '10:07',
        ),
      ],
    ),
    ChatRoom(
      id: 'battle-chat-room',
      name: 'Battle Chat Room',
      coverAsset: SquadPingAssets.chatCardKeys,
      summary: 'Exchange gunplay strategies and match tactics.',
      welcomeLine: 'Keep calls short: role, route, danger, reset.',
      topic: 'FPS tactics, loadouts, and clean team communication.',
      participants: [ivy, marco, cole, rina],
      messages: [
        ChatMessage(
          author: marco,
          message: 'Two players hold crossfire, one watches flank.',
          sentAt: '11:18',
        ),
        ChatMessage(
          author: rina,
          message: 'Save utility for the final thirty seconds.',
          sentAt: '11:21',
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
      ],
    ),
    ChatRoom(
      id: 'strategy-table',
      name: 'Strategy Table',
      coverAsset: SquadPingAssets.chatStrategyTable,
      summary: 'Turn order, card reads, and tabletop-style planning.',
      welcomeLine: 'Share the plan before the timer starts.',
      topic: 'Strategy rooms for players who like calm planning.',
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
      ],
    ),
    ChatRoom(
      id: 'esports-watch',
      name: 'Esports Watch',
      coverAsset: SquadPingAssets.chatEsportsArena,
      summary: 'Live match reactions and post-game breakdowns.',
      welcomeLine: 'No spoilers without a warning. Keep analysis readable.',
      topic: 'Watch parties, bracket talk, and pro match reviews.',
      participants: [hana, theo, rex, leo],
      messages: [
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
      ],
    ),
  ];
}
