//
//  BasePDFKitViewController.swift
//  TopsProSys
//  加载PDF
//  Created by 李桂盛 on 2019/12/26.
//  Copyright © 2019 com.topscommmac01. All rights reserved.
//

import UIKit
import PDFKit

@available(iOS 11.0, *)
open class BasePDFKitViewController: BaseUIViewViewController {

    private var pdfView: PDFView!
    private var document: PDFDocument?
    open var urlString: String = ""
    open var orientation = UIInterfaceOrientation.portrait
    
    lazy  var rotateBarButtonItem: UIBarButtonItem = {
        let path = Bundle(for: ProgressWebViewController.self).resourcePath! + "/SwiftLeeTools.bundle"
        let bundle = Bundle(path: path)!
        let image =  UIImage(named: "screen", in: bundle, compatibleWith: nil)!
        return UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(rotateDidClick(sender:)))
    }()
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showLoading()
        addBarButtonItems()
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkURL()
        
    }
    open func checkURL() {
        guard !urlString.isEmpty else {
            self.showToast(message: "请检查PDF地址!")
            self.hideHUD()
            return
        }
        setupUI()
        
    }
    private func setupUI() {
        self.pdfView = PDFView()
        self.baseView.addSubview(pdfView)
        self.pdfView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        let url = URL(string: self.urlString)!
        self.document = PDFDocument.init(url: url)
        self.pdfView.document = document
        self.pdfView.displayMode = .singlePageContinuous
        self.pdfView.autoScales = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(pdfVisible(_ :)), name:NSNotification.Name.PDFViewVisiblePagesChanged , object: nil)
        
    }
    
    open func addBarButtonItems() {
        self.navigationItem.rightBarButtonItems = [rotateBarButtonItem]
    }
    @objc func rotateDidClick(sender: AnyObject) {
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
    @objc func pdfVisible(_ noti: Notification) {
        self.hideHUD()
        //MARK:-title
        print(self.document?.documentAttributes?[PDFDocumentAttribute.titleAttribute])
    }
    //MARK:-子类重写父类关于旋转的方法
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

