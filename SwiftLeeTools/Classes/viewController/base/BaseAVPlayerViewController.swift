//
//  BaseAVPlayerViewController.swift
//  TopsProSys
//  基础播放器
//  Created by 李桂盛 on 2019/12/6.
//  Copyright © 2019 com.topscommmac01. All rights reserved.
//

import UIKit
import AVFoundation

//MARK:- AVPlayer支持的视频格式
public enum VideoType: String {
    case WMV
    case AVI
    case MKV
    case RMVB
    case RM
    case XVID
    case MP4
    case ThreeGP = "3GP"
    case MPG
}
open class BaseAVPlayerViewController: BaseUIViewViewController {

    open var url: String = ""
    
    open var type:VideoType = .MP4
    
    private var player: AVPlayer = AVPlayer.init()
    private var playItem: AVPlayerItem!
    private var playerLayer:AVPlayerLayer!
    //MARK:- 高度比例（只对竖屏状态下有效）
    private var orientation =  UIInterfaceOrientation.portrait
    open  var heightRadio: CGFloat = 1.0
    
    private var link: CADisplayLink?
    //播放器下方控件
    private var containner: UIView = UIView()
    private var timeLabel: UILabel = UILabel()
    private var playBtn: UIButton = UIButton()
    private var slider: UISlider = UISlider()
    private var sliding: Bool = false
    private var isPlaying: Bool = true
    private var progress: UIProgressView = UIProgressView()
    
    fileprivate let path = Bundle(for: ProgressWebViewController.self).resourcePath! + "/SwiftLeeTools.bundle"
    
    lazy  var rotateBarButtonItem: UIBarButtonItem = {
        let path = Bundle(for: ProgressWebViewController.self).resourcePath! + "/SwiftLeeTools.bundle"
        let bundle = Bundle(path: path)!
        let image =  UIImage(named: "screen", in: bundle, compatibleWith: nil)!
        return UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(rotateDidClick(sender:)))
    }()
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkVideoType()
        self.navigationItem.rightBarButtonItem = rotateBarButtonItem
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
                
    }
    
    open func checkVideoType() {
        if  self.type == .WMV ||
            self.type == .AVI ||
            self.type == .MKV ||
            self.type == .RMVB ||
            self.type == .RM ||
            self.type == .XVID ||
            self.type == .MP4 ||
            self.type == .ThreeGP ||
            self.type == .MPG {
            
            if url != "" {
                self.downloadVideo()
            }
        } else {
            self.show(text: "暂不支持该格式")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    //MARK:-下载  返回播放路径
    open func downloadVideo() {
        self.downloadVideo(url: url) { (path) in
            ///Users/liguicheng/Library/Developer/CoreSimulator/Devices/513E70F9-529C-47A4-A293-174E51044741/data/Containers/Data/Application/58638383-8E65-4B00-B181-FDEDA96833AD/Documents/aaaa (1).mp4
            self.playItem = AVPlayerItem.init(url: URL.init(fileURLWithPath: path))
            // 监听缓冲进度改变
            self.playItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
            // 监听状态改变
            self.playItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
            self.link = CADisplayLink.init(target: self, selector: #selector(self.updateTime))
            self.link?.add(to: RunLoop.main, forMode: RunLoop.Mode.default)
            self.setupUI()
        }
    }
    
    //MARK: -设置播放/暂停 播放进度 时间 等控件
    private func setupUI() {
        self.player = AVPlayer(playerItem: self.playItem)
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer.videoGravity = .resizeAspect
        self.baseView.layer.addSublayer(self.playerLayer)
        //横竖屏
        var frame = CGRect.zero
        if self.orientation == .portrait {
            frame = CGRect.init(x: self.baseView.X, y: 0, width: self.baseView.W, height: self.baseView.H * heightRadio)
            playerLayer.backgroundColor = UIColor.black.cgColor
            self.playerLayer.frame = frame
                        
        } else {
            self.playerLayer.frame = self.baseView.bounds
        }
        
        let bundle = Bundle(path: path)!
        
        self.baseView.addSubview(containner)
        self.containner.backgroundColor = .clear
        self.containner.frame = CGRect.init(x: frame.origin.x, y: playerLayer.frame.size.height-40, width: playerLayer.frame.size.width, height: CGFloat(ConstantsHelp.labelHeight))
        
        self.playBtn = UIButton.init()
        self.containner.addSubview(playBtn)
        playBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(ConstantsHelp.normalPadding * 2)
            make.height.equalToSuperview()
            make.width.equalTo(35)
        }
        playBtn.setImage(UIImage(named: "pause", in: bundle, compatibleWith: nil), for: .normal)
        playBtn.addTarget(self, action: #selector(playBtnClick(_ :)), for: .touchUpInside)
        
        self.containner.addSubview(timeLabel)
        self.timeLabel.textColor = .white
        self.timeLabel.font = .systemFont(ofSize: 12)
        self.timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(containner.snp.right).offset(ConstantsHelp.rightMargin * 2)
            make.height.equalToSuperview()
        }
        
        self.containner.addSubview(progress)
        progress.backgroundColor = .lightGray
        progress.tintColor = .red
        progress.progress = 0.0
        progress.snp.makeConstraints { (make) in
            make.left.equalTo(playBtn.snp.right).offset(ConstantsHelp.normalPadding * 2)
            make.right.equalTo(timeLabel.snp.left).offset(ConstantsHelp.rightMargin * 2)
            make.centerY.equalTo(containner.snp.centerY)
        }
        
        self.containner.addSubview(slider)
        
        
        let image =  UIImage(named: "Artboard", in: bundle, compatibleWith: nil)!
        slider.setThumbImage(image, for: .normal)
        slider.maximumValue = 1.0
        slider.minimumValue = 0.0
        slider.value = 0.0
        // 从最大值滑向最小值时杆的颜色
        slider.maximumTrackTintColor = UIColor.clear
        // 从最小值滑向最大值时杆的颜色
        slider.minimumTrackTintColor = UIColor.white
        // 按下的时候
        slider.addTarget(self, action: #selector(sliderTouchDown(_ :)), for: .touchDown)
        // 弹起的时候
        slider.addTarget(self, action: #selector(sliderTouchUpOut(_ :)), for: .touchUpOutside)
        slider.addTarget(self, action: #selector(sliderTouchUpOut(_ :)), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderTouchUpOut(_ :)), for: .touchCancel)
        
        slider.snp.makeConstraints { (make) in
            make.left.equalTo(progress.snp.left)
            make.right.equalTo(timeLabel.snp.left).offset(ConstantsHelp.rightMargin)
            make.centerY.equalTo(progress.snp.centerY)
            make.height.equalTo(2)
        }        
        
    }
    @objc func playBtnClick(_ sender:UIButton) {
        self.isPlaying = !isPlaying
        let bundle = Bundle(path: path)!
        if #available(iOS 13.0, *) {
            self.playBtn.setImage(isPlaying ? UIImage.init(named: "pause", in: bundle, with: nil) : UIImage.init(named: "play", in: bundle, with: nil) , for: .normal)
            self.isPlaying ? self.player.play() : self.player.pause()
        } else {
            if isPlaying {
                let image =  UIImage(named: "pause", in: bundle, compatibleWith: nil)!
                self.playBtn.setImage(image, for: .normal)
                self.player.play()
            } else {
                let image =  UIImage(named: "play", in: bundle, compatibleWith: nil)!
                self.playBtn.setImage(image, for: .normal)
                self.player.pause()
            }
        }
        
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
        self.updateFrame()
    }
    private func updateFrame() {
        var frame = CGRect.zero
        if self.orientation == .portrait {
            frame = CGRect.init(x: self.baseView.X, y: 0, width: self.baseView.W, height: self.baseView.H * heightRadio)
            playerLayer.backgroundColor = UIColor.black.cgColor
            self.playerLayer.frame = frame
        } else {
            frame = self.baseView.bounds
            self.playerLayer.frame = frame
        }
        self.containner.frame = CGRect.init(x: frame.origin.x, y: playerLayer.frame.size.height-40, width: playerLayer.frame.size.width, height: CGFloat(ConstantsHelp.labelHeight))
    }
    @objc func updateTime() {
        
        let currentTime = CMTimeGetSeconds(self.player.currentTime())
        let totalTime   = TimeInterval(playItem.duration.value) / TimeInterval(playItem.duration.timescale)
        let timeStr = "\(formatPlayTime(secounds: currentTime))/\(formatPlayTime(secounds: totalTime))"
        self.timeLabel.text = timeStr
        if !self.sliding {
            self.slider.value = Float(currentTime) / Float(totalTime)
        }
        
    }
    @objc func sliderTouchDown(_ slider:UISlider){
        self.sliding = true
    }
    @objc func sliderTouchUpOut(_ slider:UISlider){
        if self.player.status == .readyToPlay {
            let duration = slider.value * Float(CMTimeGetSeconds(self.player.currentItem!.duration))
            let seekTime = CMTimeMake(value: Int64(duration), timescale: 1)
            self.player.seek(to: seekTime) { _ in
                self.sliding = false
            }
        }
    }
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
                guard let playerItem = object as? AVPlayerItem else { return }
                if keyPath == "loadedTimeRanges"{
        //            通过监听AVPlayerItem的"loadedTimeRanges"，可以实时知道当前视频的进度缓冲
                    let loadedTime = avalableDurationWithplayerItem()
                    let totalTime = CMTimeGetSeconds(playerItem.duration)
                    let percent = loadedTime/totalTime
                    
                    self.progress.progress = Float(percent)

                }else if keyPath == "status"{
        //            AVPlayerItemStatusUnknown,AVPlayerItemStatusReadyToPlay, AVPlayerItemStatusFailed。只有当status为AVPlayerItemStatusReadyToPlay是调用 AVPlayer的play方法视频才能播放。
                    if playerItem.status == AVPlayerItem.Status.readyToPlay{
                        // 只有在这个状态下才能播放
                        self.player.play()
                    }else{
                        print("加载异常")
                    }
                }
    }
    private func avalableDurationWithplayerItem()->TimeInterval{
        guard let loadedTimeRanges = player.currentItem?.loadedTimeRanges,let first = loadedTimeRanges.first else {fatalError()}
        let timeRange = first.timeRangeValue
        let startSeconds = CMTimeGetSeconds(timeRange.start)
        let durationSecound = CMTimeGetSeconds(timeRange.duration)
        let result = startSeconds + durationSecound
        return result
    }
    private func formatPlayTime(secounds:TimeInterval)->String{
        if secounds.isNaN{
            return "00:00"
        }
        let Min = Int(secounds / 60)
        let Sec = Int(secounds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", Min, Sec)
    }
}
//MARK:-子类重写父类关于旋转的方法
extension BaseAVPlayerViewController{
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
