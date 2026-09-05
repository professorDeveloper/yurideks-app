import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';

abstract interface class ChatLocalDataSource {
  Future<String?> readConversationId();

  Future<void> writeConversationId(String conversationId);

  Future<void> clearConversationId();
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  const ChatLocalDataSourceImpl(this._preferences);

  static const String _conversationKey = 'chat.conversationId';

  final SharedPreferences _preferences;

  @override
  Future<String?> readConversationId() async {
    return _preferences.getString(_conversationKey);
  }

  @override
  Future<void> writeConversationId(String conversationId) async {
    final bool saved = await _preferences.setString(
      _conversationKey,
      conversationId,
    );
    if (!saved) {
      throw const CacheException();
    }
  }

  @override
  Future<void> clearConversationId() async {
    await _preferences.remove(_conversationKey);
  }
}
