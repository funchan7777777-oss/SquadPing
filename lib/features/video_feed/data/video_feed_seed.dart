import '../../../shared/visuals/squad_ping_assets.dart';
import '../models/video_feed_models.dart';

abstract final class VideoFeedSeed {
  static const viewer = VideoCreator(
    id: 'viewer-alex',
    displayName: 'Alex R',
    age: 20,
    country: 'USA',
    avatarAsset: SquadPingAssets.avatarMaleStreetSnap,
    bio: 'Short clips, clean plays, and weekend game highlights.',
  );

  static const esme = VideoCreator(
    id: 'esme',
    displayName: 'Esme',
    age: 20,
    country: 'USA',
    avatarAsset: SquadPingAssets.avatarFemaleNeonCat,
    bio: 'Fast edits and party queue recaps.',
  );
  static const luna = VideoCreator(
    id: 'luna',
    displayName: 'Luna',
    age: 19,
    country: 'USA',
    avatarAsset: SquadPingAssets.avatarFemaleBlondeHeadset,
    bio: 'Build battles and late-game rotations.',
  );
  static const rex = VideoCreator(
    id: 'rex',
    displayName: 'Rex',
    age: 21,
    country: 'USA',
    avatarAsset: SquadPingAssets.avatarMaleBacklitStation,
    bio: 'Spectator reads and calm clutch calls.',
  );
  static const kira = VideoCreator(
    id: 'kira',
    displayName: 'Kira',
    age: 24,
    country: 'Sweden',
    avatarAsset: SquadPingAssets.avatarFemaleCompetitiveHeadset,
    bio: 'Ranked clips with quick aim notes.',
  );
  static const axel = VideoCreator(
    id: 'axel',
    displayName: 'Axel',
    age: 24,
    country: 'USA',
    avatarAsset: SquadPingAssets.avatarMaleArcadeHost,
    bio: 'Arcade finds and story-game moments.',
  );

  static const releasePhotoOptions = <String>[
    SquadPingAssets.postRuinsDrop,
    SquadPingAssets.postCitySquare,
    SquadPingAssets.postArcadeScreen,
    SquadPingAssets.postNeonRacer,
  ];

  static const releaseVideoOptions = <VideoPost>[
    VideoPost(
      id: 'clip-tactical-rooftop',
      videoAsset: SquadPingAssets.videoTacticalRooftop,
      creator: viewer,
      caption:
          'Wind, waves and flying discs. Nothing beats beach frisbee sunset sessions.',
      likeCount: 814,
      tags: ['FPS', 'Rooftop', 'Clean angle'],
      comments: [],
    ),
    VideoPost(
      id: 'clip-battle-build',
      videoAsset: SquadPingAssets.videoBattleBuild,
      creator: luna,
      caption: 'High ground retake with a risky wall edit and a clean escape.',
      likeCount: 1290,
      tags: ['Build fight', 'Retake', 'Squad queue'],
      comments: [],
    ),
    VideoPost(
      id: 'clip-night-scope',
      videoAsset: SquadPingAssets.videoNightScope,
      creator: rex,
      caption:
          'Holding the angle until the last second. Patience wins this round.',
      likeCount: 672,
      tags: ['Scope', 'Hold', 'Tension'],
      comments: [],
    ),
    VideoPost(
      id: 'clip-arena-close',
      videoAsset: SquadPingAssets.videoArenaClose,
      creator: kira,
      caption:
          'Close-quarters pressure and a quick reset before the final push.',
      likeCount: 986,
      tags: ['Arena', 'FPS', 'Clutch'],
      comments: [],
    ),
    VideoPost(
      id: 'clip-story-escape',
      videoAsset: SquadPingAssets.videoStoryEscape,
      creator: axel,
      caption: 'Do not go too far from the squad when the story turns dark.',
      likeCount: 543,
      tags: ['Story', 'Co-op', 'Night run'],
      comments: [],
    ),
  ];

  static const posts = <VideoPost>[
    VideoPost(
      id: 'tactical-rooftop',
      videoAsset: SquadPingAssets.videoTacticalRooftop,
      creator: viewer,
      caption:
          'Wind, waves and flying discs. Nothing beats beach frisbee sunset sessions.',
      likeCount: 814,
      isLiked: false,
      isFollowed: true,
      tags: ['FPS', 'Rooftop', 'Angle'],
      attachedPhotos: [SquadPingAssets.postRuinsDrop],
      comments: [
        VideoComment(
          author: esme,
          message:
              'The timing on that peek was clean. Save this angle for ranked.',
          sentAt: '2 min ago',
        ),
        VideoComment(
          author: luna,
          message: 'I would rotate earlier, but the hold still worked.',
          sentAt: '8 min ago',
        ),
      ],
    ),
    VideoPost(
      id: 'battle-build',
      videoAsset: SquadPingAssets.videoBattleBuild,
      creator: luna,
      caption: 'High ground retake with a risky wall edit and a clean escape.',
      likeCount: 1290,
      isLiked: true,
      tags: ['Build fight', 'Retake', 'Squad queue'],
      attachedPhotos: [SquadPingAssets.postCitySquare],
      comments: [
        VideoComment(
          author: viewer,
          message: 'That reset saved the whole clip.',
          sentAt: '4 min ago',
        ),
        VideoComment(
          author: kira,
          message: 'Your camera control is getting much smoother.',
          sentAt: '12 min ago',
        ),
      ],
    ),
    VideoPost(
      id: 'night-scope',
      videoAsset: SquadPingAssets.videoNightScope,
      creator: rex,
      caption:
          'Holding the angle until the last second. Patience wins this round.',
      likeCount: 672,
      tags: ['Scope', 'Hold', 'Tension'],
      attachedPhotos: [SquadPingAssets.postArcadeScreen],
      comments: [
        VideoComment(
          author: axel,
          message: 'That silence before the hit made the clip.',
          sentAt: '19 min ago',
        ),
      ],
    ),
    VideoPost(
      id: 'arena-close',
      videoAsset: SquadPingAssets.videoArenaClose,
      creator: kira,
      caption:
          'Close-quarters pressure and a quick reset before the final push.',
      likeCount: 986,
      tags: ['Arena', 'FPS', 'Clutch'],
      attachedPhotos: [SquadPingAssets.postNeonRacer],
      comments: [
        VideoComment(
          author: esme,
          message: 'The reload discipline was perfect.',
          sentAt: '21 min ago',
        ),
        VideoComment(
          author: viewer,
          message: 'Need this loadout for tonight.',
          sentAt: '30 min ago',
        ),
      ],
    ),
    VideoPost(
      id: 'story-escape',
      videoAsset: SquadPingAssets.videoStoryEscape,
      creator: axel,
      caption: 'Do not go too far from the squad when the story turns dark.',
      likeCount: 543,
      tags: ['Story', 'Co-op', 'Night run'],
      comments: [
        VideoComment(
          author: rex,
          message: 'This is exactly the kind of clip that needs voice chat.',
          sentAt: '35 min ago',
        ),
      ],
    ),
  ];
}
