import '../../../../core/error/exceptions.dart';
import '../models/daily_law_model.dart';
import 'daily_law_bundle_data_source.dart';
import 'daily_law_remote_data_source.dart';

abstract interface class DailyLawCatalogueDataSource {
  Future<List<DailyLawModel>> readCatalogue();
}

class DailyLawCatalogueDataSourceImpl implements DailyLawCatalogueDataSource {
  DailyLawCatalogueDataSourceImpl({
    required DailyLawRemoteDataSource remote,
    required DailyLawBundleDataSource bundle,
  })  : _remote = remote,
        _bundle = bundle;

  final DailyLawRemoteDataSource _remote;
  final DailyLawBundleDataSource _bundle;

  List<DailyLawModel>? _sessionCatalogue;

  @override
  Future<List<DailyLawModel>> readCatalogue() async {
    final List<DailyLawModel>? cached = _sessionCatalogue;
    if (cached != null) {
      return cached;
    }

    final List<DailyLawModel> remote = await _remoteCatalogue();
    final List<DailyLawModel> catalogue =
        remote.isEmpty ? await _bundle.readCatalogue() : remote;

    _sessionCatalogue = catalogue;
    return catalogue;
  }

  Future<List<DailyLawModel>> _remoteCatalogue() async {
    try {
      return await _remote.readCatalogue();
    } on ServerException {
      return const <DailyLawModel>[];
    } on NetworkException {
      return const <DailyLawModel>[];
    }
  }
}
