import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_network_ios_helper/local_network_ios_helper_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  MethodChannelLocalNetworkIosHelper platform =
      MethodChannelLocalNetworkIosHelper();
  const MethodChannel channel = MethodChannel('local_network_ios_helper');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('requestAuthorization', () async {
    expect(await platform.requestAuthorization(), false);
  });
}
