import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/chat_thread.dart';

abstract interface class ChatRepository {
  Future<Either<Failure, ChatThread>> loadHistory();

  Future<Either<Failure, ChatThread>> ask(String question);
}
