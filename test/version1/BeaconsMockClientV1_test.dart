import 'package:test/test.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services_beacons_dart/pip_services_beacons_dart.dart';
import 'package:pip_clients_beacons_dart/pip_clients_beacons_dart.dart';

import './BeaconsClientV1Fixture.dart';

void main() {
  group('BeaconsMockClientV1', () {
    late BeaconsMockClientV1 client;
    late BeaconsClientV1Fixture fixture;

    setUp(() async {
      client = BeaconsMockClientV1();
      fixture = BeaconsClientV1Fixture(client);
    });

    test('CRUD Operations', () async {
      await fixture.testCrudOperations();
    });

    test('Calculate Positions', () async {
      await fixture.testCalculatePosition();
    });
  });
}
