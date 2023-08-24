import '../data/depth_datasource.dart';

abstract class DataRepository {
  Future<List<DepthEntry>> loadDate();
}
