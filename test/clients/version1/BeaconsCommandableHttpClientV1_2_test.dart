import 'dart:async';

import 'package:test/test.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_clients_beacons_dart/pip_clients_beacons_dart.dart';

import './BeaconsClientV1Fixture.dart';

var httpConfig = ConfigParams.fromTuples([
  'connection.protocol',
  'http',
  'connection.host',
  'localhost',
  'connection.port',
  3002
]);

void main() {
  group('BeaconsCommandableHttpClientV1_2', () {
    late BeaconsCommandableHttpClientV1 client;
    late BeaconsClientV1Fixture fixture;

    setUp(() async {
      client = BeaconsCommandableHttpClientV1();
      client.configure(httpConfig);
      var references = References.fromTuples(
          [Descriptor('beacons', 'client', 'http', 'default', '1.0'), client]);

      client.setReferences(references);
      fixture = BeaconsClientV1Fixture(client);

      await client.open(null);

      // clean persistence

      for (;;) {
        var page =
            await client.getBeacons('123', FilterParams(), PagingParams());
        if (page == null || page.data.isEmpty) {
          break;
        }

        for (var beacon in page.data) {
          await client.deleteBeaconById('123', beacon.id!);
        }
      }
    });

    tearDown(() async {
      await client.close(null);

      await Future.delayed(Duration(milliseconds: 2000));
    });

    test('CRUD Operations', () async {
      await fixture.testCrudOperations();
    });

    test('Calculate Position', () async {
      await fixture.testCalculatePosition();
    });
  });
}
