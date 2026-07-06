import '../../../shared/visuals/squad_ping_assets.dart';
import '../models/community_models.dart';

abstract final class CommunitySeed {
  static const viewer = CommunityUser(
    id: 'viewer-alex',
    displayName: 'Alex R',
    age: 20,
    country: 'USA',
    avatarAsset: SquadPingAssets.avatarMaleStreetSnap,
    bio: 'Looking for respectful squads, clean clips, and weekend co-op plans.',
    trendLabel: 'Rising',
  );

  static const chloe = CommunityUser(
    id: 'chloe',
    displayName: 'Chloe',
    age: 21,
    country: 'Austria',
    avatarAsset: SquadPingAssets.avatarFemaleSunlitSelfie,
    bio: 'Adventure games, city screenshots, and late-night story runs.',
    trendLabel: 'Trending',
  );
  static const liam = CommunityUser(
    id: 'liam',
    displayName: 'Liam',
    age: 23,
    country: 'UK',
    avatarAsset: SquadPingAssets.avatarMaleShadowProfile,
    bio: 'Strategy player who likes calm plans before queue.',
    trendLabel: 'Tactical',
  );
  static const julian = CommunityUser(
    id: 'julian',
    displayName: 'Julian',
    age: 24,
    country: 'Germany',
    avatarAsset: SquadPingAssets.avatarMaleBlueRoom,
    bio: 'FPS angles, quick clips, and review notes.',
    trendLabel: 'Hot',
  );
  static const zoe = CommunityUser(
    id: 'zoe-community',
    displayName: 'Zoe',
    age: 22,
    country: 'Italy',
    avatarAsset: SquadPingAssets.avatarFemaleGlassesLeopard,
    bio: 'Screenshot collector and racing-game night driver.',
    trendLabel: 'Creator',
  );
  static const maya = CommunityUser(
    id: 'maya-community',
    displayName: 'Maya',
    age: 23,
    country: 'Australia',
    avatarAsset: SquadPingAssets.avatarFemaleWhiteHeadset,
    bio: 'Co-op anchor and chat host.',
    trendLabel: 'Co-op',
  );

  static const users = <CommunityUser>[viewer, chloe, liam, julian, zoe, maya];

  static const posts = <CommunityPost>[
    CommunityPost(
      id: 'post-neon-racer',
      author: viewer,
      message:
          "There aren't many games to play lately, so what games are you all playing?",
      imageAsset: SquadPingAssets.postNeonRacer,
      likeCount: 123,
      comments: [
        CommunityComment(
          id: 'comment-neon-racer-esme',
          author: chloe,
          message:
              'I went on an outdoor trip with my best friend and we pitched a tent for the night.',
          sentAt: '12 min ago',
        ),
      ],
    ),
    CommunityPost(
      id: 'post-city-square',
      author: chloe,
      message:
          'City walk before queue. I keep finding spots that look like open-world maps.',
      imageAsset: SquadPingAssets.postCitySquare,
      likeCount: 88,
      comments: [
        CommunityComment(
          id: 'comment-city-liam',
          author: liam,
          message: 'That plaza would make a great stealth mission start.',
          sentAt: '22 min ago',
        ),
      ],
    ),
    CommunityPost(
      id: 'post-neon-arcade',
      author: liam,
      message: 'Found a neon arcade corner that feels built for squad photos.',
      imageAsset: SquadPingAssets.postCommunityNeonArcade,
      likeCount: 64,
      comments: [],
    ),
    CommunityPost(
      id: 'post-retro-arcade',
      author: julian,
      message:
          'Retro machines still make the best warmup break between ranked rounds.',
      imageAsset: SquadPingAssets.postCommunityRetroArcade,
      likeCount: 77,
      comments: [],
    ),
    CommunityPost(
      id: 'post-controller',
      author: maya,
      message:
          'Controller night. Need two more patient players for story co-op.',
      imageAsset: SquadPingAssets.postCommunityController,
      likeCount: 55,
      comments: [],
    ),
    CommunityPost(
      id: 'post-arcade-screen',
      author: zoe,
      message: 'This old game screen has perfect menu energy.',
      imageAsset: SquadPingAssets.postArcadeScreen,
      likeCount: 91,
      comments: [],
    ),
  ];
}
