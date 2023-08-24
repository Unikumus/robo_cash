import 'dart:math';

class DepthDataSource {
  final _random = Random();

  Future<List<DepthEntry>> getDepth() {
    var depth = <DepthEntry>[
      DepthEntry(96.5, _random.nextDouble(), DepthEntryType.ask),
      DepthEntry(96.3, _random.nextDouble(), DepthEntryType.ask),
      DepthEntry(96, _random.nextDouble(), DepthEntryType.ask),
      DepthEntry(95.7, _random.nextDouble(), DepthEntryType.ask),
      DepthEntry(95.5, _random.nextDouble(), DepthEntryType.ask),
      DepthEntry(95.1, _random.nextDouble(), DepthEntryType.bid),
      DepthEntry(94.6, _random.nextDouble(), DepthEntryType.bid),
      DepthEntry(93.9, _random.nextDouble(), DepthEntryType.bid),
      DepthEntry(93.6, _random.nextDouble(), DepthEntryType.bid),
      DepthEntry(93, _random.nextDouble(), DepthEntryType.bid),
    ];

    return Future.delayed(const Duration(seconds: 2)).then((_) => depth);
  }
}

class DepthEntry {
  final double price;
  final double volume;
  final DepthEntryType type;

  DepthEntry(this.price, this.volume, this.type);
}

enum DepthEntryType { ask, bid }
