import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yurideks_app/features/chat/data/datasources/chat_local_data_source.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('keeps the conversation id until it is cleared', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final ChatLocalDataSourceImpl local = ChatLocalDataSourceImpl(preferences);

    expect(await local.readConversationId(), isNull);

    await local.writeConversationId('c-42');
    expect(await local.readConversationId(), 'c-42');

    await local.clearConversationId();
    expect(await local.readConversationId(), isNull);
  });
}
