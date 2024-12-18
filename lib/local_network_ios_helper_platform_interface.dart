import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'local_network_ios_helper_method_channel.dart';

abstract class LocalNetworkIosHelperPlatform extends PlatformInterface {
  /// Constructs a LocalNetworkIosHelperPlatform.
  LocalNetworkIosHelperPlatform() : super(token: _token);

  static final Object _token = Object();

  static LocalNetworkIosHelperPlatform _instance =
      MethodChannelLocalNetworkIosHelper();

  /// The default instance of [LocalNetworkIosHelperPlatform] to use.
  ///
  /// Defaults to [MethodChannelLocalNetworkIosHelper].
  static LocalNetworkIosHelperPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LocalNetworkIosHelperPlatform] when
  /// they register themselves.
  static set instance(LocalNetworkIosHelperPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> requestAuthorization() {
    throw UnimplementedError(
        'requestAuthorization() has not been implemented.');
  }

  Future<void> openWifiSetting() {
    throw UnimplementedError('openWifiSetting() has not been implemented.');
  }
}
