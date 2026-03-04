//
//  ViewController.swift
//  OverseaH5
//
//  Created by DouXiu on 2025/9/23.
//

import UIKit
import WebViewJavascriptBridge
import WebKit

class AppWebViewController: UIViewController {
    
    var urlString: String = ""
    /// 是否背景透明
    var clearBgColor = false
    /// 是否全屏
    var fullscreen = true
    
    private var bridge: WebViewJavascriptBridge?
    
    // Pending JS dialog completion handlers (ensure always-called to avoid WKWebView crash)
    private var pendingAlertCompletion: (() -> Void)?
    private var pendingConfirmCompletion: ((Bool) -> Void)?
    private var pendingPromptCompletion: ((String?) -> Void)?

    lazy var ox_oB3m4TaC: WKWebView = {
        let webConfig = WKWebViewConfiguration()
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        webConfig.preferences = preferences
        webConfig.allowsInlineMediaPlayback = true
        webConfig.mediaTypesRequiringUserActionForPlayback = []
        let userControl = WKUserContentController()
        webConfig.userContentController = userControl
        let w = WKWebView(frame: .zero, configuration: webConfig)
        w.uiDelegate = self
        w.navigationDelegate = self
        w.allowsLinkPreview = false
        w.allowsBackForwardNavigationGestures = true
        w.scrollView.contentInsetAdjustmentBehavior = .never
        w.isOpaque = false
        w.scrollView.bounces = false
        w.scrollView.alwaysBounceVertical = false
        w.scrollView.alwaysBounceHorizontal = false
        return w
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(self.ox_oB3m4TaC)
        var frame = CGRect(origin: CGPoint.zero, size: UIScreen.main.bounds.size)
        if fullscreen == false {
            frame.origin.y = AppConfig.ox_FS5EUBk6()
        }
        self.ox_oB3m4TaC.frame = frame
 
        self.ox_Z3WOaNk8()
        self.ox_peEc5b8m()
 
        // 应用从后台切换到前台
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ox_B8YJEtKX),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ox_B8YJEtKX()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ox_M7pRTzko()
        ox_mDWdelPm()
    }

    deinit {
        ox_N9cWtm80()
        ox_mDWdelPm()
    }

    /// 发起网页请求
    private func ox_peEc5b8m() {
        if let url = URL(string: urlString) {
            let urlRequest = URLRequest(url: url)
            self.ox_oB3m4TaC.load(urlRequest)
            self.ox_VsVORBJt()
        }
    }
    
    /// 设置页面为透明
    private func ox_VsVORBJt() {
        guard clearBgColor == true else { return }
        ox_oB3m4TaC.evaluateJavaScript("document.getElementsByTagName('body')[0].style.background='rgba(0,0,0,0)'") { _, _  in
        }
        view.backgroundColor = .clear
        ox_oB3m4TaC.backgroundColor = .clear
        ox_oB3m4TaC.scrollView.backgroundColor = .clear
        ox_oB3m4TaC.scrollView.bounces = false
        ox_oB3m4TaC.scrollView.alwaysBounceVertical = false
        ox_oB3m4TaC.scrollView.alwaysBounceHorizontal = false
        ox_oB3m4TaC.isOpaque = false
    }
    
    /// 关闭webview事件
    func ox_TCT7oRBo() {
        if ox_oB3m4TaC.canGoBack {
            ox_oB3m4TaC.goBack()
            return
        }
        
        ox_N9cWtm80()
        if self.presentingViewController != nil {
            // 当前页面dismiss后，下面还是网页时，手动调用viewDidAppear
            dismiss(animated: true) {
                if let currentVC = AppConfig.ox_6faot57q() {
                    if currentVC.isKind(of: AppWebViewController.self) {
                        (currentVC as! AppWebViewController).ox_B8YJEtKX()
                    }
                }
            }
        }
    }
}

extension AppWebViewController: WKScriptMessageHandler, WebViewJavascriptBridgeBaseDelegate {
    func _evaluateJavascript(_ javascriptCommand: String!) -> String! {
        return ""
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("js call method name = \(message.name), message = \(message.body)")
        // 兼容老事件
        DispatchQueue.main.async {
            let type = message.name
            if type == "ox_TCT7oRBo" {
                self.ox_TCT7oRBo()
                
            } else if type == "toUrl" {
                if let url = message.body as? String {
                    AppWebViewController.ox_novCSyQj(url)
                }
            }
        }
    }

    func ox_Z3WOaNk8() {
        self.bridge = WebViewJavascriptBridge(self.ox_oB3m4TaC)
        self.bridge?.setWebViewDelegate(self)
        self.bridge?.registerHandler("syncAppInfo", handler: { data, callback in
            print("js call getUserIdFromObjC, data from js is %@", data as Any)
            if callback != nil {
                if let dic = data as? [String: Any] {
                    self.ox_Oj6htwfI(schemeDic: dic) { backDic in
                        callback?(backDic)
                        DispatchQueue.main.async {
                            self.ox_HWsco6pt(dic: backDic)
                        }
                    }
                }
            }
        })
        let ucController = self.ox_oB3m4TaC.configuration.userContentController
        ucController.add(AppWebViewScriptDelegateHandler(self), name: "ox_TCT7oRBo")
        ucController.add(AppWebViewScriptDelegateHandler(self), name: "toUrl")
    }

    func ox_N9cWtm80() {
        let ucController = self.ox_oB3m4TaC.configuration.userContentController
        if #available(iOS 14.0, *) {
            ucController.removeAllScriptMessageHandlers()
        } else {
            ucController.removeScriptMessageHandler(forName: "ox_TCT7oRBo")
            ucController.removeScriptMessageHandler(forName: "toUrl")
        }
    }

    func ox_HWsco6pt(dic: [String: Any]) {
        if let typeName = dic["typeName"] as? String, let isAuth = dic["isAuth"] as? Bool, let isFirst = dic["isFirst"] as? Bool {
            if isAuth || isFirst {
                return
            }
            var message = "Please click 'Go' to allow access"
            var needAlert = false
            if typeName == "getCameraStatus" {
                needAlert = true
                message = "Please allow '\(AppName)' to access your camera in your iPhone's 'Settings-Privacy-Camera' option"
                
            } else if typeName == "getPhotoStatus" {
                needAlert = true
                message = "Please allow '\(AppName)' to access your album in your iPhone's 'Settings-Privacy-Album' option"
                
            } else if typeName == "getMicStatus" {
                needAlert = true
                message = "Please allow '\(AppName)' to access your microphone in your iPhone's 'Settings-Privacy-Microphone' option"
            }

            if needAlert {
                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)

                let action1 = UIAlertAction(title: "Cancel", style: .default) { _ in
                }
                let action2 = UIAlertAction(title: "Go", style: .destructive) { _ in
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url, options: [:], completionHandler: { _ in })
                    }
                }
                alertController.addAction(action1)
                alertController.addAction(action2)
                present(alertController, animated: true)
            }
        }
    }
}

extension AppWebViewController: WKNavigationDelegate, WKUIDelegate {
    func ox_oB3m4TaC(_ ox_oB3m4TaC: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }

    func ox_oB3m4TaC(_ ox_oB3m4TaC: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func ox_oB3m4TaC(_ ox_oB3m4TaC: WKWebView, didFinish navigation: WKNavigation!) {
        ox_VsVORBJt()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    func ox_oB3m4TaC(_ ox_oB3m4TaC: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alertController = UIAlertController(title: nil, message: "Poor network, loading failed", preferredStyle: .alert)
        let action = UIAlertAction(title: "Refresh", style: .default) { _ in
            self.ox_14BYAVZg()
        }
        alertController.addAction(action)
        present(alertController, animated: true)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    func ox_14BYAVZg() {
        if self.ox_oB3m4TaC.url != nil {
            self.ox_oB3m4TaC.reload()
        } else {
            self.ox_peEc5b8m()
        }
    }

    func ox_oB3m4TaC(_ ox_oB3m4TaC: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {}

    func ox_oB3m4TaC(_ ox_oB3m4TaC: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        DispatchQueue.global().async {
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                if challenge.previousFailureCount == 0 {
                    let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
                    completionHandler(.useCredential, credential)
                } else {
                    completionHandler(.cancelAuthenticationChallenge, nil)
                }
            } else {
                completionHandler(.cancelAuthenticationChallenge, nil)
            }
        }
    }

    func ox_nevaxkDZ(_ ox_oB3m4TaC: WKWebView) {
        self.ox_14BYAVZg()
    }

    func ox_oB3m4TaC(_ ox_oB3m4TaC: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        pendingAlertCompletion = completionHandler
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            self.pendingAlertCompletion?()
            self.pendingAlertCompletion = nil
        }
        alertController.addAction(action)
        if let topVC = AppConfig.ox_6faot57q() {
            topVC.present(alertController, animated: true)
        } else {
            // Fallback to avoid crash if cannot present
            self.pendingAlertCompletion?()
            self.pendingAlertCompletion = nil
        }
    }

    func ox_oB3m4TaC(_ ox_oB3m4TaC: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        pendingConfirmCompletion = completionHandler
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.pendingConfirmCompletion?(true)
            self.pendingConfirmCompletion = nil
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.pendingConfirmCompletion?(false)
            self.pendingConfirmCompletion = nil
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        if let topVC = AppConfig.ox_6faot57q() {
            topVC.present(alertController, animated: true)
        } else {
            // Fallback default = false
            self.pendingConfirmCompletion?(false)
            self.pendingConfirmCompletion = nil
        }
    }

    func ox_oB3m4TaC(_ ox_oB3m4TaC: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        pendingPromptCompletion = completionHandler
        let alertController = UIAlertController(title: prompt, message: "", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.text = defaultText
        }
        let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
            let text = alertController.textFields?.first?.text
            self.pendingPromptCompletion?(text)
            self.pendingPromptCompletion = nil
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.pendingPromptCompletion?(nil)
            self.pendingPromptCompletion = nil
        }
        alertController.addAction(cancelAction)
        alertController.addAction(doneAction)
        if let topVC = AppConfig.ox_6faot57q() {
            topVC.present(alertController, animated: true)
        } else {
            // Fallback default = nil
            self.pendingPromptCompletion?(nil)
            self.pendingPromptCompletion = nil
        }
    }

    @available(iOS 15.0, *)
    func ox_oB3m4TaC(_ ox_oB3m4TaC: WKWebView, requestMediaCapturePermissionFor origin: WKSecurityOrigin, initiatedByFrame frame: WKFrameInfo, type: WKMediaCaptureType, decisionHandler: @escaping (WKPermissionDecision) -> Void) {
        decisionHandler(.grant)
    }
}

extension AppWebViewController {
    /// Ensure any pending JS dialog completion handlers are executed to avoid WKWebView crash
    private func ox_mDWdelPm() {
        if let alertCompletion = pendingAlertCompletion {
            alertCompletion()
            pendingAlertCompletion = nil
        }
        if let confirmCompletion = pendingConfirmCompletion {
            confirmCompletion(false)
            pendingConfirmCompletion = nil
        }
        if let promptCompletion = pendingPromptCompletion {
            promptCompletion(nil)
            pendingPromptCompletion = nil
        }
    }
    
    /// 通知三方H5刷新金币
    func ox_M1rNh2fY() {
        self.ox_oB3m4TaC.evaluateJavaScript("HttpTool.NativeToJs('recharge')") { data, error in
        }
    }
    
    /// js事件：网页展示
    @objc private func ox_B8YJEtKX() {
        self.bridge?.callHandler("onPageShow")
        self.ox_oB3m4TaC.evaluateJavaScript("window.onPageShow&&onPageShow();") { data, error in
            print("jsEvent(onPageShow): \(String(describing: data))---\(String(describing: error))")
        }
    }
    
    /// js事件：网页消失
    private func ox_M7pRTzko() {
        self.bridge?.callHandler("onPageHide")
        self.ox_oB3m4TaC.evaluateJavaScript("window.onPageHide&&onPageHide();") { data, error in
            print("jsEvent(onPageHide): \(String(describing: data))---\(String(describing: error))")
        }
    }
}
