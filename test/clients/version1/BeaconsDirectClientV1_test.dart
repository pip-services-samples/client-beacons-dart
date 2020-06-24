import 'package:test/test.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_data_microservice_dart/pip_data_microservice_dart.dart';
import 'package:pip_client_microservice_dart/pip_client_microservice_dart.dart';

import './BeaconsClientV1Fixture.dart';

void main() {
  group('BeaconsDirectClientV1', () {
    BeaconsMemoryPersistence persistence;
    BeaconsController controller;
    BeaconsDirectClientV1 client;
    BeaconsClientV1Fixture fixture;

    setUp(() async {
      persistence = BeaconsMemoryPersistence();
      persistence.configure(ConfigParams());

      controller = BeaconsController();
      controller.configure(ConfigParams());

      client = BeaconsDirectClientV1();

      var references = References.fromTuples([
        Descriptor('beacons', 'persistence', 'memory', 'default', '1.0'),
        persistence,
        Descriptor('beacons', 'controller', 'default', 'default', '1.0'),
        controller,
        Descriptor('beacons', 'client', 'direct', 'default', '1.0'),
        client
      ]);

      controller.setReferences(references);
      client.setReferences(references);

      fixture = BeaconsClientV1Fixture(client);

      await persistence.open(null);
    });

    tearDown(() async {
      await persistence.close(null);
    });

    test('CRUD Operations', () async {
      await fixture.testCrudOperations();
    });

    test('Calculate Positions', () async {
      await fixture.testCalculatePosition();
    });
  });
}
