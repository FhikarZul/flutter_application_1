import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private let callChannel = "com.example.flutter_application_1/call"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    let channel = FlutterMethodChannel(
      name: callChannel,
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )
    channel.setMethodCallHandler { call, result in
      if call.method == "makeCall" {
        AppDelegate.handleMakeCall(call: call, result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private static func handleMakeCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard
      let args = call.arguments as? [String: Any],
      let raw = args["phoneNumber"] as? String
    else {
      result(
        FlutterError(code: "INVALID_ARGUMENT", message: "phoneNumber is required", details: nil))
      return
    }
    let phoneNumber = raw.trimmingCharacters(in: .whitespacesAndNewlines)
    if phoneNumber.isEmpty {
      result(
        FlutterError(code: "INVALID_ARGUMENT", message: "phoneNumber is required", details: nil))
      return
    }
    let normalized = phoneNumber.replacingOccurrences(of: " ", with: "")
    let telString = "tel:\(normalized)"
    guard let url = URL(string: telString) else {
      result(FlutterError(code: "DIALER_ERROR", message: "Invalid phone number", details: nil))
      return
    }
    if !UIApplication.shared.canOpenURL(url) {
      result(FlutterError(code: "DIALER_ERROR", message: "Cannot open phone dialer", details: nil))
      return
    }
    UIApplication.shared.open(url, options: [:]) { success in
      if success {
        result("dialer_opened")
      } else {
        result(FlutterError(code: "DIALER_ERROR", message: "Failed to open dialer", details: nil))
      }
    }
  }
}
