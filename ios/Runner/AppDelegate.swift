import Flutter
import UIKit
import MSAL

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // MARK: - MSAL URL handling
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    // Let MSAL process the callback URL first
    if MSALPublicClientApplication.handleMSALResponse(
         url,
         sourceApplication: options[.sourceApplication] as? String
    ) {
      return true
    }

    // Fallback to Flutter's default handler
    return super.application(app, open: url, options: options)
  }
}
