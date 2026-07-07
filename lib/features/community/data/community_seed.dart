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
    followingCount: 0,
    fansCount: 0,
  );

  static const chloe = CommunityUser(
    id: 'chloe',
    displayName: 'Chloe',
    age: 21,
    country: 'Austria',
    avatarAsset: SquadPingAssets.avatarFemaleSunlitSelfie,
    bio: 'Adventure games, city screenshots, and late-night story runs.',
    trendLabel: 'Trending',
    followingCount: 18,
    fansCount: 32,
  );
  static const liam = CommunityUser(
    id: 'liam',
    displayName: 'Liam',
    age: 23,
    country: 'UK',
    avatarAsset: SquadPingAssets.avatarMaleShadowProfile,
    bio: 'Strategy player who likes calm plans before queue.',
    trendLabel: 'Tactical',
    followingCount: 11,
    fansCount: 24,
  );
  static const julian = CommunityUser(
    id: 'julian',
    displayName: 'Julian',
    age: 24,
    country: 'Germany',
    avatarAsset: SquadPingAssets.avatarMaleBlueRoom,
    bio: 'FPS angles, quick clips, and review notes.',
    trendLabel: 'Hot',
    followingCount: 22,
    fansCount: 41,
  );
  static const zoe = CommunityUser(
    id: 'zoe-community',
    displayName: 'Zoe',
    age: 22,
    country: 'Italy',
    avatarAsset: SquadPingAssets.avatarFemaleGlassesLeopard,
    bio: 'Screenshot collector and racing-game night driver.',
    trendLabel: 'Creator',
    followingCount: 15,
    fansCount: 36,
  );
  static const maya = CommunityUser(
    id: 'maya-community',
    displayName: 'Maya',
    age: 23,
    country: 'Australia',
    avatarAsset: SquadPingAssets.avatarFemaleWhiteHeadset,
    bio: 'Co-op anchor and chat host.',
    trendLabel: 'Co-op',
    followingCount: 9,
    fansCount: 28,
  );

  static const users = <CommunityUser>[viewer, chloe, liam, julian, zoe, maya];

  static const posts = <CommunityPost>[
    CommunityPost(
      id: 'post-neon-racer',
      author: viewer,
      message:
          "There aren't many games to play lately, so what games are you all playing?",
      imageAsset: SquadPingAssets.postNeonRacer,
      likeCount: 12,
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
      likeCount: 8,
      comments: [
        CommunityComment(
          id: 'comment-city-liam',
          author: liam,
          message: 'That plaza would make a great stealth mission start.',
          sentAt: '22 min ago',
        ),
        CommunityComment(
          id: 'comment-city-zoe',
          author: zoe,
          message: 'The color on the pavement feels like a racing lobby.',
          sentAt: '35 min ago',
        ),
      ],
    ),
    CommunityPost(
      id: 'post-neon-arcade',
      author: liam,
      message: 'Found a neon arcade corner that feels built for squad photos.',
      imageAsset: SquadPingAssets.postCommunityNeonArcade,
      likeCount: 16,
      comments: [
        CommunityComment(
          id: 'comment-neon-arcade-chloe',
          author: chloe,
          message: 'This would be perfect for a team profile shot.',
          sentAt: '18 min ago',
        ),
        CommunityComment(
          id: 'comment-neon-arcade-julian',
          author: julian,
          message: 'The blue light makes it look like a boss room entrance.',
          sentAt: '41 min ago',
        ),
        CommunityComment(
          id: 'comment-neon-arcade-maya',
          author: maya,
          message: 'Queue there and I am joining.',
          sentAt: '1 hr ago',
        ),
      ],
    ),
    CommunityPost(
      id: 'post-retro-arcade',
      author: julian,
      message:
          'Retro machines still make the best warmup break between ranked rounds.',
      imageAsset: SquadPingAssets.postCommunityRetroArcade,
      likeCount: 10,
      comments: [
        CommunityComment(
          id: 'comment-retro-arcade-liam',
          author: liam,
          message: 'Old cabinets always have the best button feel.',
          sentAt: '9 min ago',
        ),
        CommunityComment(
          id: 'comment-retro-arcade-zoe',
          author: zoe,
          message: 'I would spend the whole night on that row.',
          sentAt: '27 min ago',
        ),
        CommunityComment(
          id: 'comment-retro-arcade-chloe',
          author: chloe,
          message: 'This has weekend hangout energy.',
          sentAt: '46 min ago',
        ),
        CommunityComment(
          id: 'comment-retro-arcade-maya',
          author: maya,
          message: 'Warmup break approved.',
          sentAt: '1 hr ago',
        ),
      ],
    ),
    CommunityPost(
      id: 'post-controller',
      author: maya,
      message:
          'Controller night. Need two more patient players for story co-op.',
      imageAsset: SquadPingAssets.postCommunityController,
      likeCount: 6,
      comments: [
        CommunityComment(
          id: 'comment-controller-chloe',
          author: chloe,
          message: 'I can join after dinner if the pace stays chill.',
          sentAt: '7 min ago',
        ),
        CommunityComment(
          id: 'comment-controller-liam',
          author: liam,
          message: 'I can run support and call routes.',
          sentAt: '16 min ago',
        ),
        CommunityComment(
          id: 'comment-controller-julian',
          author: julian,
          message: 'Story co-op sounds better than ranked tonight.',
          sentAt: '28 min ago',
        ),
        CommunityComment(
          id: 'comment-controller-zoe',
          author: zoe,
          message: 'Save me a slot if you still need one.',
          sentAt: '39 min ago',
        ),
        CommunityComment(
          id: 'comment-controller-alex',
          author: viewer,
          message: 'I am interested if voice chat is low pressure.',
          sentAt: '52 min ago',
        ),
      ],
    ),
    CommunityPost(
      id: 'post-arcade-screen',
      author: zoe,
      message: 'This old game screen has perfect menu energy.',
      imageAsset: SquadPingAssets.postArcadeScreen,
      likeCount: 14,
      comments: [
        CommunityComment(
          id: 'comment-arcade-screen-maya',
          author: maya,
          message: 'It looks like a hidden character select screen.',
          sentAt: '11 min ago',
        ),
        CommunityComment(
          id: 'comment-arcade-screen-liam',
          author: liam,
          message: 'The glow would make a strong stream backdrop.',
          sentAt: '24 min ago',
        ),
        CommunityComment(
          id: 'comment-arcade-screen-julian',
          author: julian,
          message: 'Menu energy is exactly right.',
          sentAt: '38 min ago',
        ),
        CommunityComment(
          id: 'comment-arcade-screen-chloe',
          author: chloe,
          message: 'I want a whole photo dump from this place.',
          sentAt: '49 min ago',
        ),
        CommunityComment(
          id: 'comment-arcade-screen-alex',
          author: viewer,
          message: 'That palette would look great on a profile banner.',
          sentAt: '1 hr ago',
        ),
        CommunityComment(
          id: 'comment-arcade-screen-zoe-reply',
          author: zoe,
          message: 'I saved a few more shots for later.',
          sentAt: '1 hr ago',
        ),
      ],
    ),
  ];
}
