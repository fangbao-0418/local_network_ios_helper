import 'package:flutter_test/flutter_test.dart';
import 'package:local_network_ios_helper/local_network_ios_helper.dart';
import 'package:local_network_ios_helper/local_network_ios_helper_platform_interface.dart';
import 'package:local_network_ios_helper/local_network_ios_helper_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLocalNetworkIosHelperPlatform
    with MockPlatformInterfaceMixin
    implements LocalNetworkIosHelperPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool?> requestAuthorization() => Future.value(true);

  @override
  Future<void> openWifiSetting() => Future.value();
}

void main() {
  final LocalNetworkIosHelperPlatform initialPlatform =
      LocalNetworkIosHelperPlatform.instance;

  test('$MethodChannelLocalNetworkIosHelper is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelLocalNetworkIosHelper>());
  });

  test('getPlatformVersion', () async {
    LocalNetworkIosHelper localNetworkIosHelperPlugin = LocalNetworkIosHelper();
    MockLocalNetworkIosHelperPlatform fakePlatform =
        MockLocalNetworkIosHelperPlatform();
    LocalNetworkIosHelperPlatform.instance = fakePlatform;

    expect(await localNetworkIosHelperPlugin.getPlatformVersion(), '42');
  });

  test('requestAuthorization', () async {
    LocalNetworkIosHelper localNetworkIosHelperPlugin = LocalNetworkIosHelper();
    MockLocalNetworkIosHelperPlatform fakePlatform =
        MockLocalNetworkIosHelperPlatform();
    LocalNetworkIosHelperPlatform.instance = fakePlatform;

    expect(await localNetworkIosHelperPlugin.requestAuthorization(), '42');
  });
}
