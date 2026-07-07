class TacticalBrief {
  const TacticalBrief({
    required this.id,
    required this.gameName,
    required this.objective,
    required this.tempo,
    required this.squadSize,
    required this.title,
    required this.summary,
    required this.lines,
    required this.createdAt,
    required this.cost,
  });

  final String id;
  final String gameName;
  final String objective;
  final String tempo;
  final int squadSize;
  final String title;
  final String summary;
  final List<String> lines;
  final DateTime createdAt;
  final int cost;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'gameName': gameName,
      'objective': objective,
      'tempo': tempo,
      'squadSize': squadSize,
      'title': title,
      'summary': summary,
      'lines': lines,
      'createdAt': createdAt.toIso8601String(),
      'cost': cost,
    };
  }

  factory TacticalBrief.fromJson(Map<String, Object?> json) {
    return TacticalBrief(
      id: json['id'] as String? ?? '',
      gameName: json['gameName'] as String? ?? 'Unknown game',
      objective: json['objective'] as String? ?? 'Squad run',
      tempo: json['tempo'] as String? ?? 'Balanced',
      squadSize: json['squadSize'] as int? ?? 4,
      title: json['title'] as String? ?? 'Tactical brief',
      summary: json['summary'] as String? ?? '',
      lines:
          (json['lines'] as List?)
              ?.map((line) => line.toString())
              .toList(growable: false) ??
          const [],
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      cost: json['cost'] as int? ?? 0,
    );
  }
}
