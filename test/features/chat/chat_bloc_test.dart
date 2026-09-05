import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yurideks_app/core/constants/app_strings.dart';
import 'package:yurideks_app/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:yurideks_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:yurideks_app/features/chat/domain/entities/chat_message.dart';
import 'package:yurideks_app/features/chat/domain/usecases/ask_question.dart';
import 'package:yurideks_app/features/chat/domain/usecases/load_chat_history.dart';
import 'package:yurideks_app/features/chat/presentation/bloc/chat_bloc.dart';

import 'chat_fixtures.dart';
import 'scripted_api_client.dart';

void main() {
  ChatBloc buildBloc(
      ScriptedApiClient client, MemoryChatLocalDataSource local) {
    final ChatRepositoryImpl repository = ChatRepositoryImpl(
      ChatRemoteDataSourceImpl(client),
      local,
    );
    return ChatBloc(AskQuestion(repository), LoadChatHistory(repository));
  }

  test('shows the question while thinking and then the answered thread',
      () async {
    final ScriptedApiClient client = ScriptedApiClient(
      (RequestOptions options) async {
        if (options.method == 'POST') {
          return jsonResponse(askResultJson('c-1'), 200);
        }
        return jsonResponse(
          threadJson(
            id: 'c-1',
            messages: <Map<String, dynamic>>[
              citizenMessageJson('m-1', 'Ish haqi to‘lanmadi'),
              assistantMessageJson(
                'm-2',
                'Ariza yozing.',
                needsEscalation: true,
              ),
            ],
          ),
          200,
        );
      },
    );
    final ChatBloc bloc = buildBloc(client, MemoryChatLocalDataSource());

    final Future<List<ChatState>> states = bloc.stream.take(2).toList();
    bloc.add(const ChatQuestionSubmitted('Ish haqi to‘lanmadi'));
    final List<ChatState> emitted = await states;

    final ChatLoaded thinking = emitted.first as ChatLoaded;
    expect(thinking.isThinking, isTrue);
    expect(thinking.messages.single.content, 'Ish haqi to‘lanmadi');

    final ChatLoaded answered = emitted.last as ChatLoaded;
    expect(answered.isThinking, isFalse);
    expect(answered.errorMessage, isNull);
    expect(answered.messages.length, 2);
    expect(answered.messages.last.id, 'm-2');
    expect(answered.messages.last.author, MessageAuthor.assistant);
    expect(answered.messages.last.needsEscalation, isTrue);
    await bloc.close();
  });

  test('turns a server failure into a readable message', () async {
    final ScriptedApiClient client = ScriptedApiClient(
      (RequestOptions options) async =>
          jsonResponse(<String, dynamic>{'error': 'boom'}, 500),
    );
    final ChatBloc bloc = buildBloc(client, MemoryChatLocalDataSource());

    final Future<List<ChatState>> states = bloc.stream.take(2).toList();
    bloc.add(const ChatQuestionSubmitted('Savol'));
    final List<ChatState> emitted = await states;

    final ChatLoaded failed = emitted.last as ChatLoaded;
    expect(failed.isThinking, isFalse);
    expect(failed.errorMessage, AppStrings.serverFailure);
    expect(failed.messages.single.content, 'Savol');
    await bloc.close();
  });

  test('restores the saved thread when the chat page opens', () async {
    final ScriptedApiClient client = ScriptedApiClient(
      (RequestOptions options) async => jsonResponse(
        threadJson(
          id: 'c-9',
          messages: <Map<String, dynamic>>[
            citizenMessageJson('m-1', 'Kecha bergan savolim'),
            assistantMessageJson('m-2', 'Kechagi javob.'),
          ],
        ),
        200,
      ),
    );
    final MemoryChatLocalDataSource local = MemoryChatLocalDataSource();
    await local.writeConversationId('c-9');
    final ChatBloc bloc = buildBloc(client, local);

    final Future<List<ChatState>> states = bloc.stream.take(2).toList();
    bloc.add(const ChatOpened());
    final List<ChatState> emitted = await states;

    expect((emitted.first as ChatLoaded).isRestoring, isTrue);

    final ChatLoaded restored = emitted.last as ChatLoaded;
    expect(restored.isRestoring, isFalse);
    expect(restored.messages.length, 2);
    expect(restored.messages.first.content, 'Kecha bergan savolim');
  });

  test('opens with an empty thread when nothing was saved', () async {
    final ScriptedApiClient client = ScriptedApiClient(
      (RequestOptions options) async => throw StateError('no request expected'),
    );
    final ChatBloc bloc = buildBloc(client, MemoryChatLocalDataSource());

    bloc.add(const ChatOpened());
    final ChatLoaded settled = await bloc.stream.firstWhere(
            (ChatState state) => state is ChatLoaded && !state.isRestoring)
        as ChatLoaded;

    expect(settled.messages, isEmpty);
  });

  test('drops a thread the server no longer has', () async {
    final ScriptedApiClient client = ScriptedApiClient(
      (RequestOptions options) async => jsonResponse(<String, dynamic>{}, 404),
    );
    final MemoryChatLocalDataSource local = MemoryChatLocalDataSource();
    await local.writeConversationId('c-gone');
    final ChatBloc bloc = buildBloc(client, local);

    bloc.add(const ChatOpened());
    final ChatLoaded settled = await bloc.stream.firstWhere(
            (ChatState state) => state is ChatLoaded && !state.isRestoring)
        as ChatLoaded;

    expect(settled.messages, isEmpty);
    expect(await local.readConversationId(), isNull);
  });
}
