//
//  ProgressWebViewController.swift
//  ProgressWebViewController
//
//  Created by 350541732 on 11/26/2019.
//  Copyright (c) 2019 350541732. All rights reserved.
//

import UIKit
import WebKit
import QorumLogs

let estimatedProgressKeyPath = "estimatedProgress"
let titleKeyPath = "title"
let cookieKey = "Cookie"

@objc public protocol ProgressWebViewControllerDelegate {
    @objc optional func progressWebViewController(_ controller: ProgressWebViewController, canDismiss url: URL) -> Bool
    @objc optional func progressWebViewController(_ controller: ProgressWebViewController, didStart url: URL)
    @objc optional func progressWebViewController(_ controller: ProgressWebViewController, didFinish url: URL)
    @objc optional func progressWebViewController(_ controller: ProgressWebViewController, didFail url: URL, withError error: Error)
    @objc optional func progressWebViewController(_ controller: ProgressWebViewController, decidePolicy url: URL)
    @objc optional func progressWebViewController(_ controller: ProgressWebViewController, decidePolicy url: URL, navigationType: NavigationType) -> Bool
    @objc optional func progressWebViewController(_ controller: ProgressWebViewController, decidePolicy url: URL, response: URLResponse) -> Bool
}

open class ProgressWebViewController: BaseUIViewViewController {
    ///文件类型(格式：.pdf .txt )
    open var fileType:FileType = .pdf
    open var url: URL?
    open var bypassedSSLHosts: [String]?
    open var userAgent: String?
//    open var disableZoom = false
    open var urlsHandledByApp = [
        "hosts": ["itunes.apple.com"],
        "schemes": ["tel", "mailto", "sms"],
        "_blank": true
        ] as [String : Any]
    
    open var cookies: [HTTPCookie]? {
        didSet {
            var shouldReload = (cookies != nil && oldValue == nil) || (cookies == nil && oldValue != nil)
            if let cookies = cookies, let oldValue = oldValue, cookies != oldValue {
                shouldReload = true
            }
            if shouldReload, let url = url {
                load(url)
            }
        }
    }
    open var headers: [String: String]? {
        didSet {
            var shouldReload = (headers != nil && oldValue == nil) || (headers == nil && oldValue != nil)
            if let headers = headers, let oldValue = oldValue, headers != oldValue {
                shouldReload = true
            }
            if shouldReload, let url = url {
                load(url)
            }
        }
    }
    
    open var delegate: ProgressWebViewControllerDelegate?
    
    open var tintColor: UIColor?
    open var websiteTitleInNavigationBar = true
    open var doneBarButtonItemPosition: NavigationBarPosition = .right
    open var leftNavigaionBarItemTypes: [BarButtonItemType] = []
    open var rightNavigaionBarItemTypes: [BarButtonItemType] = [.rotate]
    open var toolbarItemTypes: [BarButtonItemType] = []
    
    var webView: WKWebView?
    var progressView: UIProgressView?
    
    var previousNavigationBarState: (tintColor: UIColor, hidden: Bool) = (.black, false)
    var previousToolbarState: (tintColor: UIColor, hidden: Bool) = (.black, false)
    
    lazy var originalUserAgent = UIWebView().stringByEvaluatingJavaScript(from: "navigator.userAgent")

    //MARK:---自己添加图片
    lazy  var backBarButtonItem: UIBarButtonItem = {
        let bundle = Bundle(for: ProgressWebViewController.self)
        return UIBarButtonItem(image: UIImage(named: "Back", in: bundle, compatibleWith: nil), style: .plain, target: self, action: #selector(backDidClick(sender:)))
    }()
    //MARK:---自己添加图片
    lazy  var forwardBarButtonItem: UIBarButtonItem = {
        let bundle = Bundle(for: ProgressWebViewController.self)
        return UIBarButtonItem(image: UIImage(named: "Forward", in: bundle, compatibleWith: nil), style: .plain, target: self, action: #selector(forwardDidClick(sender:)))
    }()
    //MARK:---自己替换图片
    lazy  var rotateBarButtonItem: UIBarButtonItem = {
        let path = Bundle(for: ProgressWebViewController.self).resourcePath! + "/SwiftLeeTools.bundle"
        let bundle = Bundle(path: path)!
        let image =  UIImage(named: "screen", in: bundle, compatibleWith: nil)!
        return UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(rotateDidClick(sender:)))
    }()
    
    lazy  var reloadBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadDidClick(sender:)))
    }()
    
    lazy  var stopBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(stopDidClick(sender:)))
    }()
    
    lazy  var activityBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(activityDidClick(sender:)))
    }()
    
    lazy  var doneBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDidClick(sender:)))
    }()
    
    lazy  var flexibleSpaceBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }()
    
    open var orientation = UIInterfaceOrientation.portrait
    
    deinit {
        webView?.removeObserver(self, forKeyPath: estimatedProgressKeyPath)
        if websiteTitleInNavigationBar {
            webView?.removeObserver(self, forKeyPath: titleKeyPath)
        }
        webView?.scrollView.delegate = nil
    }
    
    
    func setWebView(){
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        if #available(iOS 9.0, *) {
            webConfiguration.allowsAirPlayForMediaPlayback = true
        } else {
            // Fallback on earlier versions
        }
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.delegate = self as? UIScrollViewDelegate
        
        webView.allowsBackForwardNavigationGestures = true
        webView.isMultipleTouchEnabled = true
        
        webView.addObserver(self, forKeyPath: estimatedProgressKeyPath, options: .new, context: nil)
        if websiteTitleInNavigationBar {
            webView.addObserver(self, forKeyPath: titleKeyPath, options: .new, context: nil)
        }
        self.webView = webView
    }
    
    func positionWebView(){
       view = webView
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setWebView()
        positionWebView()
        // Do any additional setup after loading the view.
        navigationItem.title = navigationItem.title ?? url?.absoluteString
        
        if let navigationController = navigationController {
            previousNavigationBarState = (navigationController.navigationBar.tintColor, navigationController.navigationBar.isHidden)
            previousToolbarState = (navigationController.toolbar.tintColor, navigationController.toolbar.isHidden)
        }
        
        setUpProgressView()
        addBarButtonItems()
        
        if let userAgent = userAgent {
            if let originalUserAgent = originalUserAgent {
                if #available(iOS 9.0, *) {
                    webView?.customUserAgent = [originalUserAgent, userAgent].joined(separator: " ")
                } else {
                    // Fallback on earlier versions
                }
            }
            else {
                if #available(iOS 9.0, *) {
                    webView?.customUserAgent = userAgent
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        checkUrl()
    }
    
    func checkUrl(){

        switch fileType {
        case .txt://Txt格式
            let enc = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue))
            if let htmlString = try?String.init(contentsOf: url!, encoding:String.Encoding(rawValue: enc)) {
                let newStr = "<html><header><meta name='viewport' content='width=device-width, initial-scale=1.0, user-scalable=no'></header><body><div>\(htmlString)</div></body></html>"
                webView!.loadHTMLString(newStr, baseURL: nil)
            }else if let utf8HtmlString = try?String.init(contentsOf: url!, encoding:.utf8) {
                let newStr = "<html><header><meta name='viewport' content='width=device-width, initial-scale=1.0, user-scalable=no'></header><body><div>\(utf8HtmlString)</div></body></html>"
                self.webView?.loadHTMLString(newStr, baseURL: nil)
            }
        case .pdf: //PDF 下载
            if let resultUrl = url?.absoluteString{
                downloadPDF(url:resultUrl) { result in
                    let fileUrl = URL(fileURLWithPath:result)
                    QL1(fileUrl)
                    if #available(iOS 9.0, *) {
                        self.webView?.loadFileURL(fileUrl, allowingReadAccessTo:fileUrl)
                    }
                }
            }
        case .other:
            return
        default:
            break;
        }
        if let url = url {
            load(url)
        }
        else {
            print("[ProgressWebViewController][Error] NULL URL")
        }
    }
    
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpState()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        rollbackState()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        QL1(keyPath)
        switch keyPath {
        case estimatedProgressKeyPath?:
            guard let estimatedProgress = webView?.estimatedProgress else {
                return
            }
            progressView?.alpha = 1
            progressView?.setProgress(Float(estimatedProgress), animated: true)
            
            if estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
                    self.progressView?.alpha = 0
                }, completion: {
                    finished in
                    self.progressView?.setProgress(0, animated: false)
                })
            }
        case titleKeyPath?:
            navigationItem.title = webView?.title
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func updateProgressViewFrame() {
        guard let navigationController = navigationController, let progressView = progressView else {
            return
        }
        progressView.frame = CGRect(x: 0, y: navigationController.navigationBar.frame.size.height - progressView.frame.size.height, width: navigationController.navigationBar.frame.size.width, height: progressView.frame.size.height)
    }
    
    func setUpState() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.setToolbarHidden(toolbarItemTypes.count == 0, animated: true)
        
        if let tintColor = tintColor {
            progressView?.progressTintColor = tintColor
            navigationController?.navigationBar.tintColor = tintColor
            navigationController?.toolbar.tintColor = tintColor
        }
        
        if let progressView = progressView {
            navigationController?.navigationBar.addSubview(progressView)
        }
    }
}

// MARK: - Public Methods
extension ProgressWebViewController {
    func load(_ url: URL) {
        //判断类型
        if fileType == .other{
            self.showToast(message: "无法打开此类型文件!")
            return
        }
        guard let webView = webView else {
            return
        }
        let request = createRequest(url: url)
        DispatchQueue.main.async {
            webView.load(request)
        }
    }
    
    func goBackToFirstPage() {
        if let firstPageItem = webView?.backForwardList.backList.first {
            webView?.go(to: firstPageItem)
        }
    }
}

// MARK: - Fileprivate Methods
extension ProgressWebViewController {
    var availableCookies: [HTTPCookie]? {
        return cookies?.filter {
            cookie in
            var result = true
            if let host = url?.host, !cookie.domain.hasSuffix(host) {
                result = false
            }
            if cookie.isSecure && url?.scheme != "https" {
                result = false
            }
            
            return result
        }
    }
    
    func createRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        
        // Set up headers
        if let headers = headers {
            for (field, value) in headers {
                request.addValue(value, forHTTPHeaderField: field)
            }
        }
        
        // Set up Cookies
        if let cookies = availableCookies, let value = HTTPCookie.requestHeaderFields(with: cookies)[cookieKey] {
            request.addValue(value, forHTTPHeaderField: cookieKey)
        }

        return request
    }
    
    func setUpProgressView() {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.trackTintColor = UIColor(white: 1, alpha: 0)
        self.progressView = progressView
        updateProgressViewFrame()
    }
    
   
    
   @objc func addBarButtonItems() {
        let barButtonItems: [BarButtonItemType: UIBarButtonItem] = [
            .back: backBarButtonItem,
            .forward: forwardBarButtonItem,
            .reload: reloadBarButtonItem,
            .stop: stopBarButtonItem,
            .activity: activityBarButtonItem,
            .done: doneBarButtonItem,
            .flexibleSpace: flexibleSpaceBarButtonItem,
            .rotate:rotateBarButtonItem
        ]
        
        if presentingViewController != nil {
            switch doneBarButtonItemPosition {
            case .left:
                if !leftNavigaionBarItemTypes.contains(.done) {
                    leftNavigaionBarItemTypes.insert(.done, at: 0)
                }
            case .right:
                if !rightNavigaionBarItemTypes.contains(.done) {
                    rightNavigaionBarItemTypes.insert(.done, at: 0)
                }
            case .none:
                break
            }
        }
        
        navigationItem.leftBarButtonItems = leftNavigaionBarItemTypes.map {
            barButtonItemType in
            if let barButtonItem = barButtonItems[barButtonItemType] {
                return barButtonItem
            }
            return UIBarButtonItem()
        }
        
        navigationItem.rightBarButtonItems = rightNavigaionBarItemTypes.map {
            barButtonItemType in
            if let barButtonItem = barButtonItems[barButtonItemType] {
                return barButtonItem
            }
            return UIBarButtonItem()
        }
        
        if toolbarItemTypes.count > 0 {
            for index in 0..<toolbarItemTypes.count - 1 {
                toolbarItemTypes.insert(.flexibleSpace, at: 2 * index + 1)
            }
        }
        
        setToolbarItems(toolbarItemTypes.map {
            barButtonItemType -> UIBarButtonItem in
            if let barButtonItem = barButtonItems[barButtonItemType] {
                return barButtonItem
            }
            return UIBarButtonItem()
        }, animated: true)
    }
    
    func updateBarButtonItems() {
        backBarButtonItem.isEnabled = webView?.canGoBack ?? false
        forwardBarButtonItem.isEnabled = webView?.canGoForward ?? false
        
        let updateReloadBarButtonItem: (UIBarButtonItem, Bool) -> UIBarButtonItem = {
            [unowned self] barButtonItem, isLoading in
            switch barButtonItem {
            case self.reloadBarButtonItem:
                fallthrough
            case self.stopBarButtonItem:
                    return isLoading ? self.stopBarButtonItem : self.reloadBarButtonItem
            default:
                break
            }
            return barButtonItem
        }
        
        let isLoading = webView?.isLoading ?? false
        toolbarItems = toolbarItems?.map {
            barButtonItem -> UIBarButtonItem in
            return updateReloadBarButtonItem(barButtonItem, isLoading)
        }
        
        navigationItem.leftBarButtonItems = navigationItem.leftBarButtonItems?.map {
            barButtonItem -> UIBarButtonItem in
            return updateReloadBarButtonItem(barButtonItem, isLoading)
        }
        
        navigationItem.rightBarButtonItems = navigationItem.rightBarButtonItems?.map {
            barButtonItem -> UIBarButtonItem in
            return updateReloadBarButtonItem(barButtonItem, isLoading)
        }
    }
    
    @objc func rollbackState() {
        progressView?.removeFromSuperview()
    
        navigationController?.navigationBar.tintColor = previousNavigationBarState.tintColor
        navigationController?.toolbar.tintColor = previousToolbarState.tintColor
        
        navigationController?.setToolbarHidden(previousToolbarState.hidden, animated: false)
        navigationController?.setNavigationBarHidden(previousNavigationBarState.hidden, animated: true)
    }
    
    func checkRequestCookies(_ request: URLRequest, cookies: [HTTPCookie]) -> Bool {
        if cookies.count <= 0 {
            return true
        }
        guard let headerFields = request.allHTTPHeaderFields, let cookieString = headerFields[cookieKey] else {
            return false
        }
        
        let requestCookies = cookieString.components(separatedBy: ";").map {
            $0.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "=", maxSplits: 1).map(String.init)
        }
        
        var valid = false
        for cookie in cookies {
            valid = requestCookies.filter {
                $0[0] == cookie.name && $0[1] == cookie.value
                }.count > 0
            if !valid {
                break
            }
        }
        return valid
    }
    
    func openURLWithApp(_ url: URL) -> Bool {
        let application = UIApplication.shared
        if application.canOpenURL(url) {
            return application.openURL(url)
        }
        
        return false
    }
    
    func handleURLWithApp(_ url: URL, targetFrame: WKFrameInfo?) -> Bool {
        let hosts = urlsHandledByApp["hosts"] as? [String]
        let schemes = urlsHandledByApp["schemes"] as? [String]
        let blank = urlsHandledByApp["_blank"] as? Bool
        
        var tryToOpenURLWithApp = false
        if let host = url.host, hosts?.contains(host) ?? false {
            tryToOpenURLWithApp = true
        }
        if let scheme = url.scheme, schemes?.contains(scheme) ?? false {
            tryToOpenURLWithApp = true
        }
        if blank ?? false && targetFrame == nil {
            tryToOpenURLWithApp = true
        }
        
        return tryToOpenURLWithApp ? openURLWithApp(url) : false
    }
//MARK:-需要在Appdelegate的func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?)返回支持的方向
    @objc open func rotateDidClick(sender: AnyObject) {
        //转屏
        switch self.orientation {
        case .portrait:
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            self.orientation = .landscapeRight
        case .landscapeRight:
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            self.orientation = .portrait
        default:
            break;
        }
    }
    
    @objc func backDidClick(sender: AnyObject) {
        webView?.goBack()
    }
    
    @objc func forwardDidClick(sender: AnyObject) {
        webView?.goForward()
    }
    
    @objc func reloadDidClick(sender: AnyObject) {
        webView?.stopLoading()
        if webView?.url != nil {
            webView?.reload()
        }
        else if let url = url {
            load(url)
        }
    }
    
    @objc func stopDidClick(sender: AnyObject) {
        webView?.stopLoading()
    }
    
    @objc func activityDidClick(sender: AnyObject) {
        guard let url = url else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func doneDidClick(sender: AnyObject) {
        var canDismiss = true
        if let url = url {
            canDismiss = delegate?.progressWebViewController?(self, canDismiss: url) ?? true
        }
        if canDismiss {
            dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - WKUIDelegate
extension ProgressWebViewController: WKUIDelegate {
    
}

// MARK: - WKNavigationDelegate
extension ProgressWebViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        updateBarButtonItems()
        updateProgressViewFrame()
        if let url = webView.url {
            self.url = url
            delegate?.progressWebViewController?(self, didStart: url)
        }
    }
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateBarButtonItems()
        updateProgressViewFrame()
        if let url = webView.url {
            self.url = url
            delegate?.progressWebViewController?(self, didFinish: url)
        }
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        updateBarButtonItems()
        updateProgressViewFrame()
        if let url = webView.url {
            self.url = url
            delegate?.progressWebViewController?(self, didFail: url, withError: error)
        }
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        updateBarButtonItems()
        updateProgressViewFrame()
        if let url = webView.url {
            self.url = url
            delegate?.progressWebViewController?(self, didFail: url, withError: error)
        }
    }
    
    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let bypassedSSLHosts = bypassedSSLHosts, bypassedSSLHosts.contains(challenge.protectionSpace.host) {
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        var actionPolicy: WKNavigationActionPolicy = .allow
        defer {
            decisionHandler(actionPolicy)
        }
        guard let url = navigationAction.request.url, !url.isFileURL else {
            return
        }
        
//        if navigationAction.targetFrame == nil{
//            webView.load(navigationAction.request)
//            return
//        }
        
        if let targetFrame = navigationAction.targetFrame, !targetFrame.isMainFrame {
            return
        }
   
        if handleURLWithApp(url, targetFrame: navigationAction.targetFrame) {
            actionPolicy = .cancel
            return
        }else{
            if navigationAction.targetFrame == nil{
                webView.load(navigationAction.request)
                return
            }
        }
        
        // Ensure all available cookies are set in the navigation request
        if navigationAction.navigationType != .backForward, url.host == self.url?.host, let cookies = availableCookies, !checkRequestCookies(navigationAction.request, cookies: cookies) {
            load(url)
            actionPolicy = .cancel
            return
        }
        
        delegate?.progressWebViewController?(self, decidePolicy: url)
        
        if let navigationType = NavigationType(rawValue: navigationAction.navigationType.rawValue), let result = delegate?.progressWebViewController?(self, decidePolicy: url, navigationType: navigationType) {
            actionPolicy = result ? .allow : .cancel
        }
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        var responsePolicy: WKNavigationResponsePolicy = .allow
        defer {
            decisionHandler(responsePolicy)
        }
        guard let url = navigationResponse.response.url, !url.isFileURL else {
            return
        }
        
        if let result = delegate?.progressWebViewController?(self, decidePolicy: url, response: navigationResponse.response) {
            responsePolicy = result ? .allow : .cancel
        }
    }
    
    @objc public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: "",message: message, preferredStyle: .alert)
        let okAciton = UIAlertAction(title:"确定",style:.default,handler: {action in
            completionHandler()
        })
        alertController.addAction(okAciton)
        present(alertController, animated: true, completion: nil)
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "",message: message, preferredStyle: .alert)
        let okAciton = UIAlertAction(title:"确定",style:.default,handler: {action in
            completionHandler(true)
        })
        let cancelAciton = UIAlertAction(title:"取消",style:.cancel,handler: {action in
            completionHandler(false)
        })
        alertController.addAction(okAciton)
        alertController.addAction(cancelAciton)
        present(alertController, animated: true, completion: nil)
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title:prompt,message: "", preferredStyle: .alert)
        alertController.addTextField {(textField: UITextField!) -> Void in
            textField.clearButtonMode = .whileEditing
            textField.text = defaultText
        }
        let okAciton = UIAlertAction(title:"完成",style:.default,handler: {action in
            if alertController.textFields != nil,alertController.textFields!.count > 0 {
                completionHandler(alertController.textFields![0].text)
            }else{
                completionHandler("")
            }
        })
        alertController.addAction(okAciton)
        present(alertController, animated: true, completion: nil)
    }
}

//extension ProgressWebViewController: UIScrollViewDelegate {
//    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return disableZoom ? nil : scrollView.subviews[0]
//    }
//}

//MARK:-子类重写父类关于旋转的方法
extension ProgressWebViewController{
    open override var shouldAutorotate: Bool{
        return true
    }
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .all
    }
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .portrait
    }
}
