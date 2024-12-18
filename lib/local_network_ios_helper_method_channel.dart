import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'local_network_ios_helper_platform_interface.dart';

/// An implementation of [LocalNetworkIosHelperPlatform] that uses method channels.
class MethodChannelLocalNetworkIosHelper extends LocalNetworkIosHelperPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('local_network_ios_helper');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool?> requestAuthorization() async {
    final res = await methodChannel.invokeMethod<bool>('requestAuthorization');
    return res;
  }

  @override
  Future<bool?> openWifiSetting() async {
    final res = await methodChannel.invokeMethod<bool>('openWifiSetting');
    return res;
  }
}
