import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_components/pip_services3_components.dart';

import '../pip_clients_beacons_dart.dart';

class BeaconsClientFactory extends Factory {
  static var NullClientV1Descriptor =
      Descriptor('pip-services-beacons', 'client', 'null', '*', '1.0');
  static var MockClientV1Descriptor =
      Descriptor('pip-services-beacons', 'client', 'mock', '*', '1.0');
  static var DirectClientV1Descriptor =
      Descriptor('pip-services-beacons', 'client', 'direct', '*', '1.0');
  static var HttpClientV1Descriptor =
      Descriptor('pip-services-beacons', 'client', 'http', '*', '1.0');
  static var LambdaClientV1Descriptor =
      Descriptor('pip-services-beacons', 'client', 'lambda', '*', '1.0');

  BeaconsClientFactory() : super() {
    registerAsType(
        BeaconsClientFactory.NullClientV1Descriptor, BeaconsNullClientV1);
    registerAsType(
        BeaconsClientFactory.MockClientV1Descriptor, BeaconsMockClientV1);
    registerAsType(
        BeaconsClientFactory.DirectClientV1Descriptor, BeaconsDirectClientV1);
    registerAsType(
        BeaconsClientFactory.HttpClientV1Descriptor, BeaconsHttpClientV1);
  }
}
