import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure_message.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/daily_law.dart';
import '../../domain/entities/law_collection.dart';
import '../../domain/usecases/read_collection.dart';

part 'collection_event.dart';
part 'collection_state.dart';

class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  CollectionBloc(this._readCollection) : super(const CollectionInitial()) {
    on<CollectionRequested>(_onRequested);
  }

  final ReadCollection _readCollection;

  Future<void> _onRequested(
    CollectionRequested event,
    Emitter<CollectionState> emit,
  ) async {
    emit(const CollectionLoading());
    final Either<Failure, LawCollection> result =
        await _readCollection(const NoParams());
    emit(
      result.fold(
        (Failure failure) => CollectionError(FailureMessage.of(failure)),
        (LawCollection collection) => CollectionLoaded(
          laws: collection.laws,
          catalogueSize: collection.catalogueSize,
        ),
      ),
    );
  }
}
