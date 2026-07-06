enum PlayerGender { female, male }

class PlayerProfile {
  const PlayerProfile({
    required this.id,
    required this.displayName,
    required this.age,
    required this.country,
    required this.gender,
    required this.avatarAsset,
    required this.playStyle,
  });

  final String id;
  final String displayName;
  final int age;
  final String country;
  final PlayerGender gender;
  final String avatarAsset;
  final String playStyle;
}

class GameComment {
  const GameComment({
    required this.author,
    required this.message,
    required this.postedAt,
  });

  final PlayerProfile author;
  final String message;
  final String postedAt;
}

class GameTitle {
  const GameTitle({
    required this.id,
    required this.name,
    required this.coverAsset,
    required this.rating,
    required this.summary,
    required this.detail,
    required this.tags,
    required this.hotLevel,
    required this.comments,
  });

  final String id;
  final String name;
  final String coverAsset;
  final double rating;
  final String summary;
  final String detail;
  final List<String> tags;
  final int hotLevel;
  final List<GameComment> comments;
}

class ChatMessage {
  const ChatMessage({
    required this.author,
    required this.message,
    required this.sentAt,
    this.fromViewer = false,
  });

  final PlayerProfile author;
  final String message;
  final String sentAt;
  final bool fromViewer;
}

class ChatRoom {
  const ChatRoom({
    required this.id,
    required this.name,
    required this.coverAsset,
    required this.summary,
    required this.welcomeLine,
    required this.topic,
    required this.memberCount,
    required this.participants,
    required this.messages,
  });

  final String id;
  final String name;
  final String coverAsset;
  final String summary;
  final String welcomeLine;
  final String topic;
  final int memberCount;
  final List<PlayerProfile> participants;
  final List<ChatMessage> messages;
}
