//
//  AppConfig.swift
//  OverseaH5
//
//  Created by young on 2025/9/24.
//

import KeychainSwift
import UIKit

/*: "zxqply" :*/
fileprivate let app_domainPart:String = "cobdeg"
fileprivate let user_hostSuffix:String = "alox"
public let ReplaceUrlDomain = (app_domainPart.replacingOccurrences(of: "b", with: "") + user_hostSuffix.replacingOccurrences(of: "o", with: ""))
/// 包ID
let PackageID = "2015"
/// Adjust
let AdjustKey = "z648kdz7ztog"
let AdInstallToken = "4zrtl4"

/// 网络版本号
let AppNetVersion = "1.9.1"
let H5WebDomain = "https://m.\(ReplaceUrlDomain).com"
let AppVersion =
    Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
let AppBundle = Bundle.main.bundleIdentifier!
let AppName = Bundle.main.infoDictionary!["CFBundleDisplayName"] ?? ""
let AppBuildNumber =
    Bundle.main.infoDictionary!["CFBundleVersion"] as! String

class AppConfig: NSObject {
    /// 获取状态栏高度
    class func ox_FS5EUBk6() -> CGFloat {
        if #available(iOS 13.0, *) {
            if let statusBarManager = UIApplication.shared.windows.first?
                .windowScene?.statusBarManager
            {
                return statusBarManager.statusBarFrame.size.height
            }
        } else {
            return UIApplication.shared.statusBarFrame.size.height
        }
        return 20.0
    }

    /// 获取window
    class func ox_uZ8RPXEH() -> UIWindow {
        var window = UIApplication.shared.windows.first(where: {
            $0.isKeyWindow
        })
        // 是否为当前显示的window
        if window?.windowLevel != UIWindow.Level.normal {
            let windows = UIApplication.shared.windows
            for windowTemp in windows {
                if windowTemp.windowLevel == UIWindow.Level.normal {
                    window = windowTemp
                    break
                }
            }
        }
        return window!
    }

    /// 获取当前控制器
    class func ox_6faot57q() -> (UIViewController?) {
        var window = AppConfig.ox_uZ8RPXEH()
        if window.windowLevel != UIWindow.Level.normal {
            let windows = UIApplication.shared.windows
            for windowTemp in windows {
                if windowTemp.windowLevel == UIWindow.Level.normal {
                    window = windowTemp
                    break
                }
            }
        }
        let vc = window.rootViewController
        return ox_6faot57q(vc)
    }

    class func ox_6faot57q(_ vc: UIViewController?)
        -> UIViewController?
    {
        if vc == nil {
            return nil
        }
        if let presentVC = vc?.presentedViewController {
            return ox_6faot57q(presentVC)
        } else if let tabVC = vc as? UITabBarController {
            if let selectVC = tabVC.selectedViewController {
                return ox_6faot57q(selectVC)
            }
            return nil
        } else if let naiVC = vc as? UINavigationController {
            return ox_6faot57q(naiVC.visibleViewController)
        } else {
            return vc
        }
    }
}

// MARK: - Device
extension UIDevice {
    static var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") {
            identifier, element in
            guard let value = element.value as? Int8, value != 0 else {
                return identifier
            }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }

    /// 获取当前系统时区
    static var timeZone: String {
        let currentTimeZone = NSTimeZone.system
        return currentTimeZone.identifier
    }

    /// 获取当前系统语言
    static var langCode: String {
        let language = Locale.preferredLanguages.first
        return language ?? ""
    }

    /// 获取接口语言
    static var interfaceLang: String {
        let lang = UIDevice.ox_SNws2KyZ()
        if ["en", "ar", "es", "pt"].contains(lang) {
            return lang
        }
        return "en"
    }

    /// 获取当前系统地区
    static var countryCode: String {
        let locale = Locale.current
        let countryCode = locale.regionCode
        return countryCode ?? ""
    }

    /// 获取系统UUID（每次调用都会产生新值，所以需要keychain）
    static var systemUUID: String {
        let key = KeychainSwift()
        if let value = key.get(AdjustKey) {
            return value
        } else {
            let value = NSUUID().uuidString
            key.set(value, forKey: AdjustKey)
            return value
        }
    }

    /// 获取已安装应用信息
    static var getInstalledApps: String {
        var appsArr: [String] = []
        if UIDevice.ox_Ab5d4n8J("weixin") {
            appsArr.append("weixin")
        }
        if UIDevice.ox_Ab5d4n8J("wxwork") {
            appsArr.append("wxwork")
        }
        if UIDevice.ox_Ab5d4n8J("dingtalk") {
            appsArr.append("dingtalk")
        }
        if UIDevice.ox_Ab5d4n8J("lark") {
            appsArr.append("lark")
        }
        if appsArr.count > 0 {
            return appsArr.joined(separator: ",")
        }
        return ""
    }

    /// 判断是否安装app
    static func ox_Ab5d4n8J(_ scheme: String) -> Bool {
        let url = URL(string: "\(scheme)://")!
        if UIApplication.shared.canOpenURL(url) {
            return true
        }
        return false
    }

    /// 获取系统语言
    /// - Returns: 国际通用语言Code
    @objc public class func ox_SNws2KyZ() -> String {
        let language = NSLocale.preferredLanguages.first
        let array = language?.components(separatedBy: "-")
        return array?.first ?? "en"
    }
}
