import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  
  // Static variable to track if the API key was already set
  static var isApiKeySet = false
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let apiChannel = FlutterMethodChannel(name: "com.wuct/api", binaryMessenger: controller.binaryMessenger)
    
    apiChannel.setMethodCallHandler { (call: FlutterMethodCall, result: FlutterResult) in
      if call.method == "setApiKey" {
        if let apiKey = call.arguments as? String {
          // Check if the API key has already been set
          if !AppDelegate.isApiKeySet {
            GMSServices.provideAPIKey(apiKey)
            AppDelegate.isApiKeySet = true
          }
          result(nil) // Success
        } else {
          result(FlutterError(code: "API_KEY_ERROR", message: "API Key not provided", details: nil))
        }
      }
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
