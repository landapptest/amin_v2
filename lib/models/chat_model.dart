class ChatModel {
  final String chatId;
  final List<String> participants;
  final int updatedAt;

  ChatModel({
    required this.chatId,
    required this.participants,
    required this.updatedAt,
  });

  factory ChatModel.fromJson(String chatId, Map<String, dynamic> json) {
    final participantList = <String>[];
    if (json['participants'] is List) {
      for (final p in (json['participants'] as List)) {
        participantList.add(p as String);
      }
    }
    return ChatModel(
      chatId: chatId,
      participants: participantList,
      updatedAt: json['updatedAt'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participants': participants,
      'updatedAt': updatedAt,
    };
  }
}
