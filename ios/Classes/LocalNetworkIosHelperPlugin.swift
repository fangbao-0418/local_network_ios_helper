import Flutter
import UIKit

public class LocalNetworkIosHelperPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "local_network_ios_helper", binaryMessenger: registrar.messenger())
    let instance = LocalNetworkIosHelperPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func triggerLocalNetworkPrivacyAlert() {
    let addresses = selectedLinkLocalIPv6Addresses()
    for address in addresses {
        let sock6 = socket(AF_INET6, SOCK_DGRAM, 0)
        guard sock6 >= 0 else { return }
        defer { close(sock6) }


        withUnsafePointer(to: address) { sa6 in
            sa6.withMemoryRebound(to: sockaddr.self, capacity: 1) { sa in
                _ = connect(sock6, sa, socklen_t(sa.pointee.sa_len)) >= 0
            }
        }
    }
  }

  public func selectedLinkLocalIPv6Addresses() -> [sockaddr_in6]
  {
      let r1 = (0..<8).map { _ in UInt8.random(in: 0...255) }
      let r2 = (0..<8).map { _ in UInt8.random(in: 0...255) }
      return Array(ipv6AddressesOfBroadcastCapableInterfaces()
          .filter { isIPv6AddressLinkLocal($0) }
          .map { var addr = $0 ; addr.sin6_port = UInt16(9).bigEndian ; return addr }
          .map { [setIPv6LinkLocalAddressHostPart(of: $0, to: r1), setIPv6LinkLocalAddressHostPart(of: $0, to: r2)] }
          .joined())
  }

  public func setIPv6LinkLocalAddressHostPart(of address: sockaddr_in6, to hostPart: [UInt8]) -> sockaddr_in6 {
      precondition(hostPart.count == 8)
      var result = address
      withUnsafeMutableBytes(of: &result.sin6_addr) { buf in
          buf[8...].copyBytes(from: hostPart)
      }
      return result
  }

  public func isIPv6AddressLinkLocal(_ address: sockaddr_in6) -> Bool {
      address.sin6_addr.__u6_addr.__u6_addr8.0 == 0xfe
          && (address.sin6_addr.__u6_addr.__u6_addr8.1 & 0xc0) == 0x80
  }

  public func ipv6AddressesOfBroadcastCapableInterfaces() -> [sockaddr_in6] {
    var addrList: UnsafeMutablePointer<ifaddrs>? = nil
    let err = getifaddrs(&addrList)
    guard err == 0, let start = addrList else { return [] }
    defer { freeifaddrs(start) }
    return sequence(first: start, next: { $0.pointee.ifa_next })
        .compactMap { i -> sockaddr_in6? in
            guard
                (i.pointee.ifa_flags & UInt32(bitPattern: IFF_BROADCAST)) != 0,
                let sa = i.pointee.ifa_addr,
                sa.pointee.sa_family == AF_INET6,
                sa.pointee.sa_len >= MemoryLayout<sockaddr_in6>.size
            else { return nil }
            return UnsafeRawPointer(sa).load(as: sockaddr_in6.self)
        }
  }


  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)

    case "requestAuthorization":
      triggerLocalNetworkPrivacyAlert()
      result(true)
    case "openWifiSetting":
      if let wifiUrl = URL(string: "App-Prefs:WIFI"), UIApplication.shared.canOpenURL(wifiUrl) {
        UIApplication.shared.open(wifiUrl, options:[:], completionHandler: nil)
        return
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
