import 'local_network_ios_helper_platform_interface.dart';

class LocalNetworkIosHelper {
  Future<String?> getPlatformVersion() {
    return LocalNetworkIosHelperPlatform.instance.getPlatformVersion();
  }

  Future<bool?> requestAuthorization() {
    return LocalNetworkIosHelperPlatform.instance.requestAuthorization();
  }

  Future<void> openWifiSetting() {
    return LocalNetworkIosHelperPlatform.instance.openWifiSetting();
  }
}
