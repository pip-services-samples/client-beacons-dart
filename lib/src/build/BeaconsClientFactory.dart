import 'package:pip_services3_components/pip_services3_components.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

import '../clients/version1/BeaconsNullClientV1.dart';
import '../clients/version1/BeaconsDirectClientV1.dart';
import '../clients/version1/BeaconsCommandableHttpClientV1.dart';


class BeaconsClientFactory extends Factory {
  static final NullClientDescriptor =
      Descriptor('beacons', 'client', 'null', '*', '1.0');
  static final DirectClientDescriptor =
      Descriptor('beacons', 'client', 'direct', '*', '1.0');
  static final CommandableHttpClientDescriptor =
      Descriptor('beacons', 'client', 'commandable-http', '*', '1.0');

  BeaconsClientFactory() : super() {
    registerAsType(
        BeaconsClientFactory.NullClientDescriptor, BeaconsNullClientV1);
    registerAsType(
        BeaconsClientFactory.DirectClientDescriptor, BeaconsDirectClientV1);
    registerAsType(BeaconsClientFactory.CommandableHttpClientDescriptor,
        BeaconsCommandableHttpClientV1);
  
  }
}
