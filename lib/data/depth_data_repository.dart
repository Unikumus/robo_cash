import '../domain/data_repository.dart';
import 'depth_datasource.dart';

class DepthDataRepository implements DataRepository {
  DepthDataSource dataSource = DepthDataSource();

  @override
  Future<List<DepthEntry>> loadDate() async {
    return await dataSource.getDepth();
  }
}
