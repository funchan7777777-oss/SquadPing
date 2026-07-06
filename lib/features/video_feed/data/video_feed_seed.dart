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
      caption: 'Rooftop angle held just long enough to stop the push.',
      likeCount: 48,
      tags: ['FPS', 'Rooftop', 'Clean angle'],
      comments: [],
    ),
    VideoPost(
      id: 'clip-battle-build',
      videoAsset: SquadPingAssets.videoBattleBuild,
      creator: luna,
      caption: 'High ground retake with a risky wall edit and a clean escape.',
      likeCount: 63,
      tags: ['Build fight', 'Retake', 'Squad queue'],
      comments: [],
    ),
    VideoPost(
      id: 'clip-night-scope',
      videoAsset: SquadPingAssets.videoNightScope,
      creator: rex,
      caption:
          'Holding the angle until the last second. Patience wins this round.',
      likeCount: 31,
      tags: ['Scope', 'Hold', 'Tension'],
      comments: [],
    ),
    VideoPost(
      id: 'clip-arena-close',
      videoAsset: SquadPingAssets.videoArenaClose,
      creator: kira,
      caption:
          'Close-quarters pressure and a quick reset before the final push.',
      likeCount: 57,
      tags: ['Arena', 'FPS', 'Clutch'],
      comments: [],
    ),
    VideoPost(
      id: 'clip-story-escape',
      videoAsset: SquadPingAssets.videoStoryEscape,
      creator: axel,
      caption: 'Do not go too far from the squad when the story turns dark.',
      likeCount: 42,
      tags: ['Story', 'Co-op', 'Night run'],
      comments: [],
    ),
  ];

  static const posts = <VideoPost>[
    VideoPost(
      id: 'tactical-rooftop',
      videoAsset: SquadPingAssets.videoTacticalRooftop,
      creator: viewer,
      caption: 'Rooftop angle held just long enough to stop the push.',
      likeCount: 48,
      isLiked: false,
      isFollowed: true,
      tags: ['FPS', 'Rooftop', 'Angle'],
      attachedPhotos: [SquadPingAssets.postRuinsDrop],
      comments: [
        VideoComment(
          author: esme,
          message:
              'That corner hold was clean. I would keep this as a ranked opener.',
          sentAt: '6 min ago',
        ),
        VideoComment(
          author: luna,
          message:
              'Good patience. The second swing came right after the sound cue.',
          sentAt: '14 min ago',
        ),
      ],
    ),
    VideoPost(
      id: 'battle-build',
      videoAsset: SquadPingAssets.videoBattleBuild,
      creator: luna,
      caption: 'High ground retake with a risky wall edit and a clean escape.',
      likeCount: 63,
      isLiked: true,
      tags: ['Build fight', 'Retake', 'Squad queue'],
      attachedPhotos: [SquadPingAssets.postCitySquare],
      comments: [
        VideoComment(
          author: rex,
          message:
              'The reset after losing height made the clip feel controlled.',
          sentAt: '9 min ago',
        ),
        VideoComment(
          author: kira,
          message: 'Your camera control is getting much smoother.',
          sentAt: '17 min ago',
        ),
        VideoComment(
          author: esme,
          message: 'I like the wall edit, but the escape route sold it.',
          sentAt: '25 min ago',
        ),
      ],
    ),
    VideoPost(
      id: 'night-scope',
      videoAsset: SquadPingAssets.videoNightScope,
      creator: rex,
      caption:
          'Holding the angle until the last second. Patience wins this round.',
      likeCount: 31,
      tags: ['Scope', 'Hold', 'Tension'],
      attachedPhotos: [SquadPingAssets.postArcadeScreen],
      comments: [
        VideoComment(
          author: axel,
          message: 'The quiet hold before the shot made this feel tense.',
          sentAt: '22 min ago',
        ),
      ],
    ),
    VideoPost(
      id: 'arena-close',
      videoAsset: SquadPingAssets.videoArenaClose,
      creator: kira,
      caption:
          'Close-quarters pressure and a quick reset before the final push.',
      likeCount: 57,
      tags: ['Arena', 'FPS', 'Clutch'],
      attachedPhotos: [SquadPingAssets.postNeonRacer],
      comments: [
        VideoComment(
          author: esme,
          message: 'The reload discipline was perfect.',
          sentAt: '11 min ago',
        ),
        VideoComment(
          author: rex,
          message: 'That reset bought just enough space for the last trade.',
          sentAt: '24 min ago',
        ),
        VideoComment(
          author: luna,
          message: 'Close fights look better when the movement stays simple.',
          sentAt: '33 min ago',
        ),
      ],
    ),
    VideoPost(
      id: 'story-escape',
      videoAsset: SquadPingAssets.videoStoryEscape,
      creator: axel,
      caption: 'Do not go too far from the squad when the story turns dark.',
      likeCount: 42,
      tags: ['Story', 'Co-op', 'Night run'],
      comments: [
        VideoComment(
          author: rex,
          message:
              'This is exactly the kind of scene where voice chat matters.',
          sentAt: '18 min ago',
        ),
        VideoComment(
          author: kira,
          message: 'The lighting makes the route feel unsafe in a good way.',
          sentAt: '29 min ago',
        ),
        VideoComment(
          author: esme,
          message:
              'I would follow the squad marker instead of checking corners alone.',
          sentAt: '37 min ago',
        ),
        VideoComment(
          author: luna,
          message: 'Good clip for a co-op warning post.',
          sentAt: '44 min ago',
        ),
      ],
    ),
  ];
}
