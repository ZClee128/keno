//
//  AppDelegate.swift
//  OverseaH5
//
//  Created by DouXiu on 2025/9/23.
//

import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications
import AVFAudio
import FirebaseRemoteConfig

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    let waitVC = WaitViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = waitVC
        self.window?.makeKeyAndVisible()
        ox_uMTW6dB2()
        let config = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        settings.fetchTimeout = 5
        config.configSettings = settings
        config.fetch { (status, error) -> Void in
            if status == .success {
                config.activate { changed, error in
                    let remoteVersion = config.configValue(forKey: "Keno").numberValue.intValue
                    let appVersion = Int(AppVersion.replacingOccurrences(of: ".", with: "")) ?? 0
                    if remoteVersion > appVersion { // 远程配置大于App当前版本，进入B面
                        self.ox_Dfz0rLaA(application)
                        
                    } else { // 展示A面
                        self.ox_oqTySqg6()
                    }
                }
            } else { // 远程配置获取失败，验证本地时间戳
                let endTimeInterval: TimeInterval = 1774858708 // 预设时间(秒)
                if Date().timeIntervalSince1970 > endTimeInterval && self.ox_VVndW4nZ() { // 本地时间戳大于预设时间，进入B面
                    self.ox_Dfz0rLaA(application)
                    
                } else { // 展示A面
                    self.ox_oqTySqg6()
                }
            }
        }
        return true
    }

    /// 是否iPAD
    private func ox_VVndW4nZ() -> Bool {
        return UIDevice.current.userInterfaceIdiom != .pad
     }
    
    /// 初始化项目
    private func ox_Dfz0rLaA(_ application: UIApplication) {
        ox_AkfhvP8G(application)
        AppAdjustManager.shared.ox_iPuZPKQD()
        // 检查是否有未完成的支付订单
        AppleIAPManager.shared.ox_5iq4EkG1()
        // 支持后台播放音乐
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
        DispatchQueue.main.async {
            let vc = AppWebViewController()
            vc.urlString = "\(H5WebDomain)/dist/index.html#/?packageId=\(PackageID)&safeHeight=\(AppConfig.ox_FS5EUBk6())"
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
        }
    }
    
    private func ox_oqTySqg6() {
        DispatchQueue.main.async {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("Failed to set AVAudioSession category: \(error)")
            }
            // Initialize Root View Controller (Guest Mode: Tab Bar)
            if UserDefaults.standard.bool(forKey: "has_agreed_to_privacy") {
                let tabBar = WLDMainTab()
                self.window?.rootViewController = tabBar
            } else {
                let agreementVC = WLDLaunchAgreementViewController()
                self.window?.rootViewController = agreementVC
            }
            
            self.window?.overrideUserInterfaceStyle = .light
            self.window?.makeKeyAndVisible()
        }
    }
    
    func ox_0BsIkPfu() {
        let tabBar = WLDMainTab()
        window?.rootViewController = tabBar
        
        // Animated transition
        if let window = window {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
}

// MARK: - Firebase
extension AppDelegate: MessagingDelegate {
    private func ox_uMTW6dB2() {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
    }
    
    func ox_AkfhvP8G(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in
            })
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 注册远程通知, 将deviceToken传递过去
        let deviceStr = deviceToken.map { String(format: "%02hhx", $0) }.joined()
        Messaging.messaging().apnsToken = deviceToken
        print("APNS Token = \(deviceStr)")
        Messaging.messaging().token { token, error in
            if let error = error {
                print("error = \(error)")
            } else if let token = token {
                print("token = \(token)")
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler(.newData)
    }
  
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    // 注册推送失败回调
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("didFailToRegisterForRemoteNotificationsWithError = \(error.localizedDescription)")
    }
    
    public func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        print("didReceiveRegistrationToken = \(dataDict)")
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict)
    }
}
