class CommunityUser {
  const CommunityUser({
    required this.id,
    required this.displayName,
    required this.age,
    required this.country,
    required this.avatarAsset,
    required this.bio,
    required this.trendLabel,
    required this.followingCount,
    required this.fansCount,
  });

  final String id;
  final String displayName;
  final int age;
  final String country;
  final String avatarAsset;
  final String bio;
  final String trendLabel;
  final int followingCount;
  final int fansCount;
}

class CommunityComment {
  const CommunityComment({
    required this.id,
    required this.author,
    required this.message,
    required this.sentAt,
  });

  final String id;
  final CommunityUser author;
  final String message;
  final String sentAt;
}

class CommunityPost {
  const CommunityPost({
    required this.id,
    required this.author,
    required this.message,
    required this.imageAsset,
    required this.likeCount,
    required this.comments,
    this.isLiked = false,
  });

  final String id;
  final CommunityUser author;
  final String message;
  final String imageAsset;
  final int likeCount;
  final List<CommunityComment> comments;
  final bool isLiked;

  CommunityPost copyWith({
    String? id,
    CommunityUser? author,
    String? message,
    String? imageAsset,
    int? likeCount,
    List<CommunityComment>? comments,
    bool? isLiked,
  }) {
    return CommunityPost(
      id: id ?? this.id,
      author: author ?? this.author,
      message: message ?? this.message,
      imageAsset: imageAsset ?? this.imageAsset,
      likeCount: likeCount ?? this.likeCount,
      comments: comments ?? this.comments,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}

class LocalChatMessage {
  const LocalChatMessage({
    required this.id,
    required this.peerUserId,
    required this.text,
    required this.sentAt,
    required this.fromViewer,
  });

  final String id;
  final String peerUserId;
  final String text;
  final DateTime sentAt;
  final bool fromViewer;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'peerUserId': peerUserId,
      'text': text,
      'sentAt': sentAt.toIso8601String(),
      'fromViewer': fromViewer,
    };
  }

  static LocalChatMessage fromJson(Map<String, Object?> json) {
    return LocalChatMessage(
      id: json['id'] as String,
      peerUserId: json['peerUserId'] as String,
      text: json['text'] as String,
      sentAt:
          DateTime.tryParse(json['sentAt'] as String? ?? '') ?? DateTime.now(),
      fromViewer: json['fromViewer'] as bool? ?? true,
    );
  }
}
