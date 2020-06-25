import 'package:test/test.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services_beacons_dart/pip_services_beacons_dart.dart';
import 'package:pip_clients_beacons_dart/pip_clients_beacons_dart.dart';


final BEACON1 = BeaconV1(
    id: '1',
    udi: '00001',
    type: BeaconTypeV1.altBeacon,
    site_id: '1',
    label: 'TestBeacon1',
    center: {
      'type': 'Point',
      'coordinates': [0.0, 0.0]
    },
    radius: 50.0);
final BEACON2 = BeaconV1(
    id: '2',
    udi: '00002',
    type: BeaconTypeV1.iBeacon,
    site_id: '1',
    label: 'TestBeacon2',
    center: {
      'type': 'Point',
      'coordinates': [2.0, 2.0]
    },
    radius: 70.0);

class BeaconsClientV1Fixture {
  IBeaconsClientV1 _client;

  BeaconsClientV1Fixture(IBeaconsClientV1 client) {
    expect(client, isNotNull);
    _client = client;
  }

  void testCrudOperations() async {
    BeaconV1 beacon1;

    // Create the first beacon
    var beacon = await _client.createBeacon('123', BEACON1);
    expect(beacon, isNotNull);
    expect(BEACON1.udi, beacon.udi);
    expect(BEACON1.site_id, beacon.site_id);
    expect(BEACON1.type, beacon.type);
    expect(BEACON1.label, beacon.label);
    expect(beacon.center, isNotNull);

    // Create the second beacon
    beacon = await _client.createBeacon('123', BEACON2);
    expect(beacon, isNotNull);
    expect(BEACON2.udi, beacon.udi);
    expect(BEACON2.site_id, beacon.site_id);
    expect(BEACON2.type, beacon.type);
    expect(BEACON2.label, beacon.label);
    expect(beacon.center, isNotNull);

    // Get all beacons
    var page = await _client.getBeacons('123', FilterParams(), PagingParams());
    expect(page, isNotNull);
    expect(page.data.length, 2);
    beacon1 = page.data[0];

    // Update the beacon
    beacon1.label = 'ABC';

    beacon = await _client.updateBeacon('123', beacon1);
    expect(beacon, isNotNull);
    expect(beacon1.id, beacon.id);
    expect('ABC', beacon.label);

    // Get beacon by udi
    beacon = await _client.getBeaconByUdi('123', beacon1.udi);
    expect(beacon, isNotNull);
    expect(beacon1.id, beacon.id);

    // Delete the beacon
    beacon = await _client.deleteBeaconById('123', beacon1.id);
    expect(beacon, isNotNull);
    expect(beacon1.id, beacon.id);

    // Try to get deleted beacon
    beacon = await _client.getBeaconById('123', beacon1.id);
    expect(beacon, isNull);

  }

  void testCalculatePosition() async {
    // Create the first beacon
    var beacon = await _client.createBeacon('123', BEACON1);
    expect(beacon, isNotNull);
    expect(BEACON1.udi, beacon.udi);
    expect(BEACON1.site_id, beacon.site_id);
    expect(BEACON1.type, beacon.type);
    expect(BEACON1.label, beacon.label);
    expect(beacon.center, isNotNull);

    // Create the second beacon
    beacon = await _client.createBeacon('123', BEACON2);
    expect(beacon, isNotNull);
    expect(BEACON2.udi, beacon.udi);
    expect(BEACON2.site_id, beacon.site_id);
    expect(BEACON2.type, beacon.type);
    expect(BEACON2.label, beacon.label);
    expect(beacon.center, isNotNull);

    // Calculate position for one beacon
    var position = await _client.calculatePosition('123', '1', ['00001']);
    expect(position, isNotNull);
    expect('Point', position['type']);
    expect((position['coordinates'] as List).length, 2);
    expect(0, (position['coordinates'] as List)[0]);
    expect(0, (position['coordinates'] as List)[1]);

    // Calculate position for two beacons
    position = await _client.calculatePosition('123', '1', ['00001', '00002']);
    expect(position, isNotNull);
    expect('Point', position['type']);
    expect((position['coordinates'] as List).length, 2);
    expect(1, (position['coordinates'] as List)[0]);
    expect(1, (position['coordinates'] as List)[1]);
  }
}
