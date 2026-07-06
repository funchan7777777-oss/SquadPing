class VideoCreator {
  const VideoCreator({
    required this.id,
    required this.displayName,
    required this.age,
    required this.country,
    required this.avatarAsset,
    required this.bio,
  });

  final String id;
  final String displayName;
  final int age;
  final String country;
  final String avatarAsset;
  final String bio;
}

class VideoComment {
  const VideoComment({
    required this.author,
    required this.message,
    required this.sentAt,
  });

  final VideoCreator author;
  final String message;
  final String sentAt;
}

class VideoPost {
  const VideoPost({
    required this.id,
    required this.videoAsset,
    required this.creator,
    required this.caption,
    required this.likeCount,
    required this.comments,
    required this.tags,
    this.isLiked = false,
    this.isFollowed = false,
    this.attachedPhotos = const [],
  });

  final String id;
  final String videoAsset;
  final VideoCreator creator;
  final String caption;
  final int likeCount;
  final List<VideoComment> comments;
  final List<String> tags;
  final bool isLiked;
  final bool isFollowed;
  final List<String> attachedPhotos;

  VideoPost copyWith({
    String? id,
    String? videoAsset,
    VideoCreator? creator,
    String? caption,
    int? likeCount,
    List<VideoComment>? comments,
    List<String>? tags,
    bool? isLiked,
    bool? isFollowed,
    List<String>? attachedPhotos,
  }) {
    return VideoPost(
      id: id ?? this.id,
      videoAsset: videoAsset ?? this.videoAsset,
      creator: creator ?? this.creator,
      caption: caption ?? this.caption,
      likeCount: likeCount ?? this.likeCount,
      comments: comments ?? this.comments,
      tags: tags ?? this.tags,
      isLiked: isLiked ?? this.isLiked,
      isFollowed: isFollowed ?? this.isFollowed,
      attachedPhotos: attachedPhotos ?? this.attachedPhotos,
    );
  }
}

class VideoDraftResult {
  const VideoDraftResult({
    required this.caption,
    required this.videoAsset,
    required this.attachedPhotos,
    required this.cost,
  });

  final String caption;
  final String videoAsset;
  final List<String> attachedPhotos;
  final int cost;
}
