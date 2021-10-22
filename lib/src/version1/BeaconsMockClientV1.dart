import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services_beacons_dart/pip_services_beacons_dart.dart';

import 'version1.dart';

class BeaconsMockClientV1 implements IBeaconsClientV1 {
  int _maxPageSize = 100;
  List<BeaconV1> _items = [];

  BeaconsMockClientV1([List<BeaconV1>? items]) {
    _items = items ?? _items;
  }

  bool Function(BeaconV1) _composeFilter(FilterParams? filter) {
    filter = filter ?? FilterParams();

    var id = filter.getAsNullableString('id');
    var siteId = filter.getAsNullableString('site_id');
    var label = filter.getAsNullableString('label');
    var udi = filter.getAsNullableString('udi');
    var udis = filter.getAsObject('udis');
    if (udis != null && udis is String) {
      udis = udis.split(',');
    }
    if (udis != null && !(udis is List)) {
      udis = null;
    }

    return (item) {
      if (id != null && item.id != id) {
        return false;
      }
      if (siteId != null && item.site_id != siteId) {
        return false;
      }
      if (label != null && item.label != label) {
        return false;
      }
      if (udi != null && item.udi != udi) {
        return false;
      }
      if (udis != null && !(udis as List).contains(item.udi)) {
        return false;
      }
      return true;
    };
  }

  @override
  Future<DataPage<BeaconV1>?> getBeacons(
      String? correlationId, FilterParams? filter, PagingParams? paging) async {
    var filterBeacons = _composeFilter(filter);
    var beacons = _items.where((element) => filterBeacons(element));

    // Extract a page
    paging = paging ?? PagingParams();
    var skip = paging.getSkip(-1);
    var take = paging.getTake(_maxPageSize);

    var total;
    if (paging.total) total = beacons.length;

    if (skip > 0) {
      beacons = beacons.skip(skip);
    }
    beacons = beacons.take(take);

    var page = DataPage<BeaconV1>(beacons.toList(), total ?? beacons.length);

    return page;
  }

  @override
  Future<Map<String, dynamic>?> calculatePosition(
      String? correlationId, String siteId, List<String>? udis) async {
    List<BeaconV1> beacons;
    Map<String, dynamic>? position;

    if (udis == null || udis.isEmpty) {
      return null;
    }

    return await Future(() async {
      var page = await getBeacons(correlationId,
          FilterParams.fromTuples(['site_id', siteId, 'udis', udis]), null);
      return beacons = page?.data ?? [];
    }).then((beacons) {
      double lat = 0;
      double lng = 0;
      int count = 0;

      for (var beacon in beacons) {
        if (beacon.center != null &&
            beacon.center!['type'] == 'Point' &&
            beacon.center!['coordinates'] is List) {
          lng += beacon.center!['coordinates'][0];
          lat += beacon.center!['coordinates'][1];
          count += 1;
        }
      }

      if (count > 0) {
        position = {
          'type': 'Point',
          'coordinates': [lng / count, lat / count]
        };
      }

      return position;
    });
  }

  @override
  Future<BeaconV1?> createBeacon(String? correlationId, BeaconV1 beacon) async {
    beacon.fromJson(beacon.toJson()); // copy

    beacon.id = beacon.id ?? IdGenerator.nextLong();

    _items.add(beacon);

    return beacon;
  }

  @override
  Future<BeaconV1?> updateBeacon(String? correlationId, BeaconV1 beacon) async {
    var index = _items.map((e) => e.id).toList().indexOf(beacon.id);

    if (index < 0) {
      return null;
    }

    beacon.fromJson(beacon.toJson()); // copy

    _items[index] = beacon;

    return beacon;
  }

  @override
  Future<BeaconV1?> deleteBeaconById(
      String? correlationId, String beaconId) async {
    var index = _items.map((e) => e.id).toList().indexOf(beaconId);
    var item = _items[index];

    if (index < 0) {
      return null;
    }

    _items.removeAt(index);

    return item;
  }

  @override
  Future<BeaconV1?> getBeaconById(
      String? correlationId, String beaconId) async {
    var beacons = _items.where((e) => e.id == beaconId).toList();
    var beacon = beacons.isNotEmpty ? beacons[0] : null;

    return beacon;
  }

  @override
  Future<BeaconV1?> getBeaconByUdi(String? correlationId, String udi) async {
    var beacons = _items.where((e) => e.udi == udi).toList();
    var beacon = beacons.isNotEmpty ? beacons[0] : null;

    return beacon;
  }
}
