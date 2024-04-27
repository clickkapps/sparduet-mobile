import UIKit
import Flutter
import PhotoEditorSDK

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // This example replaces some of the default icons with symbol images provided by SF Symbols.
    // Create a symbol configuration with scale variant large as the default is too small for our use case.
    let config = UIImage.SymbolConfiguration(scale: .large)
    PESDK.bundleImageBlock = { identifier in
      if identifier == "imgly_icon_save" {
//         return UIImage(named: "imgly_icon_approve_44pt")
            return UIImage(systemName: "checkmark.circle", withConfiguration: config)?.icon(pt: 44, alpha: 0.6)

      }
      return nil
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}


// Helper extension for replacing default icons with custom icons.
private extension UIImage {
  /// Create a new icon image for a specific size by centering the input image and optionally applying alpha blending.
  /// - Parameters:
  ///   - pt: Icon size in point (pt).
  ///   - alpha: Icon alpha value.
  /// - Returns: A new icon image.
  func icon(pt: CGFloat, alpha: CGFloat = 1) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(CGSize(width: pt, height: pt), false, scale)
    let position = CGPoint(x: (pt - size.width) / 2, y: (pt - size.height) / 2)
    draw(at: position, blendMode: .normal, alpha: alpha)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }
}
