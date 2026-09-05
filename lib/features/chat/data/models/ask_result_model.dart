class AskResultModel {
  const AskResultModel({required this.conversationId, required this.messageId});

  factory AskResultModel.fromJson(Map<String, dynamic> json) {
    return AskResultModel(
      conversationId: json['conversationId'] as String,
      messageId: json['messageId'] as String,
    );
  }

  final String conversationId;
  final String messageId;
}
