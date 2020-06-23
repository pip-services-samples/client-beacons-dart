import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';

import '../../../src/data/version1/BeaconV1.dart';
import './IBeaconsClientV1.dart';

class BeaconsNullClientV1 implements IBeaconsClientV1 {
  @override
  Future<DataPage<BeaconV1>> getBeacons(
      String correlationId, FilterParams filter, PagingParams paging) async {
    return DataPage<BeaconV1>([], 0);
  }

  @override
  Future<BeaconV1> getBeaconById(String correlationId, String beaconId) async {
    return null;
  }

  @override
  Future<BeaconV1> getBeaconByUdi(String correlationId, String udi) async {
    return null;
  }

  @override
  Future<Map<String, dynamic>> calculatePosition(
      String correlationId, String siteId, List<String> udis) async {
    return null;
  }

  @override
  Future<BeaconV1> createBeacon(String correlationId, BeaconV1 beacon) {
    return null;
  }

  @override
  Future<BeaconV1> updateBeacon(String correlationId, BeaconV1 beacon) {
    return null;
  }

  @override
  Future<BeaconV1> deleteBeaconById(String correlationId, String beaconId) {
    return null;
  }
}
