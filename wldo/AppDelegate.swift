//
//  AppDelegate.swift
//  wldo
//
//  Created by zclee on 2026/1/27.
//

import UIKit
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configure AVAudioSession for background audio
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set AVAudioSession category: \(error)")
        }
        
        // Window Setup
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Initialize Root View Controller (Guest Mode: Tab Bar)
        let tabBar = WLDMainTab()
        window?.rootViewController = tabBar
        window?.overrideUserInterfaceStyle = .light
        window?.makeKeyAndVisible()
        
        // WLDJunk initialization
        WLDJunk.initialize()
        return true
    }

    func switchToMainApp() {
        let tabBar = WLDMainTab()
        window?.rootViewController = tabBar
        
        // Animated transition
        if let window = window {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }


}

