import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yurideks_app/core/error/failures.dart';
import 'package:yurideks_app/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:yurideks_app/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:yurideks_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:yurideks_app/features/chat/domain/entities/chat_message.dart';
import 'package:yurideks_app/features/chat/domain/entities/chat_thread.dart';
import 'package:yurideks_app/features/chat/domain/entities/citation.dart';

import 'chat_fixtures.dart';
import 'scripted_api_client.dart';

void main() {
  ChatRepositoryImpl buildRepository(
    ScriptedApiClient client,
    ChatLocalDataSource local,
  ) {
    return ChatRepositoryImpl(ChatRemoteDataSourceImpl(client), local);
  }

  test('asks for identifiers first and reads the answer afterwards', () async {
    final MemoryChatLocalDataSource local = MemoryChatLocalDataSource();
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
                'Mehnat kodeksi bo‘yicha ariza yozing.',
                citations: <Map<String, dynamic>>[citationJson()],
              ),
            ],
          ),
          200,
        );
      },
    );

    final Either<Failure, ChatThread> result =
        await buildRepository(client, local).ask('Ish haqi to‘lanmadi');

    final ChatThread thread = result.getOrElse(() => throw StateError('left'));
    expect(client.calls.map((RequestOptions o) => o.path), <String>[
      '/api/ask',
      '/api/conversations/c-1',
    ]);
    expect(bodyOf(client.calls.first).containsKey('conversationId'), isFalse);
    expect(thread.id, 'c-1');
    expect(thread.messages.length, 2);
    expect(thread.messages.first.author, MessageAuthor.citizen);
    expect(
        thread.messages.last.content, 'Mehnat kodeksi bo‘yicha ariza yozing.');
    final Citation citation = thread.messages.last.citations.single;
    expect(citation.source, 'LABOR_CODE');
    expect(citation.article, '175');
    expect(local.conversationId, 'c-1');
  });

  test('reuses the stored conversation id so the thread keeps context',
      () async {
    final MemoryChatLocalDataSource local = MemoryChatLocalDataSource(
      conversationId: 'c-7',
    );
    final ScriptedApiClient client = ScriptedApiClient(
      (RequestOptions options) async {
        if (options.method == 'POST') {
          return jsonResponse(askResultJson('c-7'), 200);
        }
        return jsonResponse(
          threadJson(
            id: 'c-7',
            messages: <Map<String, dynamic>>[
              assistantMessageJson('m-9', 'Xuddi shu ish beruvchi haqida.'),
            ],
          ),
          200,
        );
      },
    );

    await buildRepository(client, local).ask('U qancha muddat beradi?');

    expect(bodyOf(client.calls.first)['conversationId'], 'c-7');
    expect(client.calls.last.path, '/api/conversations/c-7');
    expect(local.conversationId, 'c-7');
  });

  test('drops a conversation id the server no longer knows and starts over',
      () async {
    final MemoryChatLocalDataSource local = MemoryChatLocalDataSource(
      conversationId: 'stale',
    );
    final ScriptedApiClient client = ScriptedApiClient(
      (RequestOptions options) async {
        if (options.method != 'POST') {
          return jsonResponse(
            threadJson(
              id: 'c-2',
              messages: <Map<String, dynamic>>[
                assistantMessageJson('m-1', 'Yangi suhbat.'),
              ],
            ),
            200,
          );
        }
        if (bodyOf(options).containsKey('conversationId')) {
          return jsonResponse(<String, dynamic>{'error': 'yo‘q'}, 404);
        }
        return jsonResponse(askResultJson('c-2'), 200);
      },
    );

    final Either<Failure, ChatThread> result =
        await buildRepository(client, local).ask('Yangi savol');

    expect(result.isRight(), isTrue);
    expect(client.calls.length, 3);
    expect(local.conversationId, 'c-2');
  });

  test('offers a lawyer only when the server raises the escalation flag',
      () async {
    Future<Either<Failure, ChatThread>> askWith({
      required bool needsEscalation,
      required List<Map<String, dynamic>> citations,
    }) {
      final ScriptedApiClient client = ScriptedApiClient(
        (RequestOptions options) async {
          if (options.method == 'POST') {
            return jsonResponse(askResultJson('c-3'), 200);
          }
          return jsonResponse(
            threadJson(
              id: 'c-3',
              messages: <Map<String, dynamic>>[
                assistantMessageJson(
                  'm-1',
                  'Salom!',
                  citations: citations,
                  needsEscalation: needsEscalation,
                ),
              ],
            ),
            200,
          );
        },
      );
      return buildRepository(client, MemoryChatLocalDataSource()).ask('Salom');
    }

    final ChatThread greeting = (await askWith(
      needsEscalation: false,
      citations: const <Map<String, dynamic>>[],
    ))
        .getOrElse(() => throw StateError('left'));
    final ChatThread escalated = (await askWith(
      needsEscalation: true,
      citations: <Map<String, dynamic>>[citationJson()],
    ))
        .getOrElse(() => throw StateError('left'));

    expect(greeting.messages.single.citations, isEmpty);
    expect(greeting.messages.single.needsEscalation, isFalse);
    expect(escalated.messages.single.citations, isNotEmpty);
    expect(escalated.messages.single.needsEscalation, isTrue);
  });

  test('maps a rejected request to a failure', () async {
    final ScriptedApiClient client = ScriptedApiClient(
      (RequestOptions options) async => jsonResponse(
        <String, dynamic>{'error': 'Savol juda qisqa', 'code': null},
        400,
      ),
    );

    final Either<Failure, ChatThread> result = await buildRepository(
      client,
      MemoryChatLocalDataSource(),
    ).ask('a');

    expect(
      result.swap().getOrElse(() => const UnknownFailure()),
      const ValidationFailure(message: 'Savol juda qisqa'),
    );
  });
}

Map<String, dynamic> bodyOf(RequestOptions options) {
  final Object? data = options.data;
  if (data is Map<String, dynamic>) {
    return data;
  }
  if (data is String) {
    return jsonDecode(data) as Map<String, dynamic>;
  }
  return <String, dynamic>{};
}
