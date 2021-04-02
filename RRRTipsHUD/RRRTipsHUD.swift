//
//  RRRTipsHUD.swift
//  RRRTips
//
//  Created by RRRenJ on 2020/11/16.
//

import UIKit


let kRRRTipsResourceBundleName = "RRRTipsResourece"
let RRRTips_width = UIScreen.main.bounds.width
let RRRTips_height = UIScreen.main.bounds.height
let RRRTips_content_max_width = RRRTips_width * 4 / 5
let RRRTips_content_max_height = RRRTips_height * 4 / 5
let RRRTips_image_width : CGFloat = 40

public class RRRTipsHUD : NSObject {
    
    static let `default` = RRRTipsHUD()
    
    var hideTimeSeconds : TimeInterval = 2
    
    private var contentView: RRRTipsContentView?
    
    private var progress : CGFloat = 0
    
    private lazy var backgroundView: RRRTipsBackgroundView = {
        let view = RRRTipsBackgroundView(frame: UIScreen.main.bounds)
        return view
    }()
    
    private override init() {
        super.init()
        
    }

}



public extension RRRTipsHUD {

    class func show(_ message : String, inView : UIView? = nil) {
        DispatchQueue.main.async {
            RRRTipsHUD.default.setupViews(imageName: nil, message: message, matherView: inView)
        }
    }
    
    class func showSuccess(_ message : String? = nil, inView : UIView? = nil) {
        DispatchQueue.main.async {
            RRRTipsHUD.default.setupViews(imageName: "rrrtipshud_success", message: message, matherView: inView)
        }
    }
    
    class func showError(_ message : String? = nil, inView : UIView? = nil) {
        DispatchQueue.main.async {
            RRRTipsHUD.default.setupViews(imageName: "rrrtipshud_error", message: message, matherView: inView)
        }
    }
    
    class func showLoading(_ message : String? = nil, inView : UIView? = nil) {
        DispatchQueue.main.async {
            RRRTipsHUD.default.setupViews(imageName: "__loading", message: message, matherView: inView)
        }
    }
    
    class func showProgress(_ message: String? = nil, inView : UIView? = nil) {
        DispatchQueue.main.async {
            RRRTipsHUD.default.progress = 0
            RRRTipsHUD.default.setupViews(imageName: "__progress", message: message, matherView: inView)
        }
    }
    
    class func updateProgress(_ progress : CGFloat, inView : UIView? = nil) {
        DispatchQueue.main.async {
            if let view = RRRTipsHUD.default.contentView?.progressView {
                view.updateProgress(progress)
                if progress >= 1 && RRRTipsHUD.default.progress < 1 {
                    RRRTipsHUD.default.perform(#selector(hideHUDAnimation(matherView:)), with: inView, afterDelay: 0.5)
                }
                RRRTipsHUD.default.progress = progress
            }
        }
    }
    
    class func hideHUD(inView : UIView? = nil){
        DispatchQueue.main.async {
            RRRTipsHUD.default.hideHUD(matherView: inView)
        }
        
    }
    
}


private extension RRRTipsHUD {
    func setupViews(imageName : String?, message : String?, matherView : UIView?)  {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hideHUDAnimation(matherView:)), object: matherView)
        self.hideHUD(matherView: matherView)
        self.contentView = RRRTipsContentView.init(imageName: imageName, message: message)
        
        if matherView == nil {
            if let window = UIApplication.shared.windows.first {
                window.addSubview(self.backgroundView)
            }
            self.backgroundView.addSubview(self.contentView!)
        }else{
            matherView!.addSubview(self.contentView!)
        }
        let size = self.contentView!.sizeThatFits(CGSize(width: RRRTips_content_max_width, height: RRRTips_content_max_height))
        self.contentView!.frame.size = size
        self.contentView!.layer.shadowPath = UIBezierPath(rect: self.contentView!.bounds).cgPath
        self.contentView!.center = self.contentView!.superview!.center
        self.contentView!.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.1) {
            self.contentView!.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        if imageName != "__loading" && imageName != "__progress" {
            self.perform(#selector(hideHUDAnimation(matherView:)), with: matherView, afterDelay: self.hideTimeSeconds + 0.3)
        }

    }
    
    @objc func hideHUDAnimation(matherView : UIView?)  {
        UIView.animate(withDuration: 0.3) {
            self.contentView!.alpha = 0
            self.contentView!.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        } completion: { (finish) in
            if finish {
                self.hideHUD(matherView: matherView)
            }
        }
    }
    
    
    func hideHUD(matherView : UIView?) {
        if matherView == nil {
            if let window = UIApplication.shared.windows.first {
                _ = window.subviews.map({ (subview)in
                    if subview is RRRTipsBackgroundView {
                       _ = subview.subviews.map{$0.removeFromSuperview()}
                        subview.removeFromSuperview()
                    }
                })
            }
        }else{
            _ = matherView!.subviews.map({ (subview) in
                if subview is RRRTipsContentView {
                    subview.removeFromSuperview()
                }
            })
        }
        self.contentView = nil
    }
    
}




private class RRRTipsContentView: UIView {
    
    private var imageView : UIImageView?
    
    private var messageLb : UILabel?
    
    private var indicatiorView : UIActivityIndicatorView?
    
    var progressView : RRRTipsCycleView?

    var contentEdge = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    var margin : CGFloat = 5
    
    var minSize = CGSize(width: 0, height: 0)
    
    init(imageName : String? , message : String?) {
        super.init(frame: .zero)
        self.setupViews(imageName: imageName, message: message)
        self.backgroundColor = .black
        self.layer.cornerRadius = 8
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = .zero
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

private extension RRRTipsContentView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let hasImage = self.imageView != nil
        let hasMessage = self.messageLb != nil
        let hasIndicatior = self.indicatiorView != nil
        let hasProgress = self.progressView != nil
        let contentSize = self.sizeThanFits(size: (CGSize(width: RRRTips_content_max_width, height: RRRTips_content_max_height)), minSize: nil)
        var y = self.contentEdge.top
        if hasImage {
            var frame = self.imageView!.frame
            frame.origin.x = contentSize.width / 2 - RRRTips_image_width / 2
            frame.origin.y = y
            self.imageView!.frame = frame
            if hasIndicatior {
                self.indicatiorView!.center = CGPoint(x: RRRTips_image_width / 2, y: RRRTips_image_width / 2)
            }
            if hasProgress {
                self.progressView!.center = CGPoint(x: RRRTips_image_width / 2, y: RRRTips_image_width / 2)
            }
            y = self.contentEdge.top + self.margin + RRRTips_image_width
        }
        if hasMessage {
            let lbWidth = contentSize.width - (self.contentEdge.left + self.contentEdge.right)
            let lbSize = self.messageLb!.sizeThatFits(CGSize(width: lbWidth , height: CGFloat.greatestFiniteMagnitude))
            var frame = self.messageLb!.frame
            frame.origin.x = self.contentEdge.left
            frame.origin.y = y
            frame.size.width = lbWidth
            frame.size.height = lbSize.height
            self.messageLb!.frame = frame
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        self.sizeThanFits(size: size, minSize: self.minSize)
    }
}


private extension RRRTipsContentView{
    
    func setupViews(imageName : String?, message : String?)  {

        if let strCount = imageName?.count, strCount > 0 {
            self.imageView = UIImageView()
            self.imageView!.bounds = CGRect(x: 0, y: 0, width: RRRTips_image_width, height: RRRTips_image_width)
            self.imageView!.contentMode = .center
            if imageName == "__loading" {
                self.indicatiorView = UIActivityIndicatorView(style: .whiteLarge)
                self.indicatiorView!.startAnimating()
                self.imageView!.addSubview(self.indicatiorView!)
            }else if imageName == "__progress"{
                self.progressView = RRRTipsCycleView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
                self.imageView!.addSubview(self.progressView!)
            }else{
                self.imageView!.image = RRRTipsContentView.image(name: imageName!)
            }
            self.addSubview(self.imageView!)
            if imageName != "__progress" && imageName != "__loading" {
                self.imageView!.isHidden = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.imageView!.isHidden = false
                    self.imageView!.transform = CGAffineTransform(scaleX: 0, y: 0)
                    UIView.animate(withDuration: 0.2) {
                        self.imageView!.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }
                }
            }
        }
        if let strCount = message?.count, strCount > 0 {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 10
            paragraphStyle.lineBreakMode = .byWordWrapping
            paragraphStyle.alignment = .center
            self.messageLb = UILabel()
            self.messageLb!.attributedText = NSAttributedString.init(string: message!, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.paragraphStyle : paragraphStyle])
            self.messageLb!.numberOfLines = 0
            self.addSubview(self.messageLb!)
        }
        
    }
    
    func sizeThanFits(size : CGSize, minSize : CGSize?) -> CGSize {
        let hasImage = self.imageView != nil
        let hasMessage = self.messageLb != nil
        
        var width : CGFloat = 0;
        var height : CGFloat = 0;
        
        let maxContentWidth = size.width - (self.contentEdge.left + self.contentEdge.right)
        let maxContentHeight = size.height - (self.contentEdge.top + self.contentEdge.bottom)
        
        if hasImage {
            width = min(maxContentWidth, max(width, self.imageView!.bounds.size.width))
            height += (self.imageView!.frame.height + (hasMessage ? self.margin : 0))
        }
        if hasMessage {
            let lbSize = self.messageLb!.sizeThatFits(CGSize(width: maxContentWidth, height: maxContentHeight))
            width = min(maxContentWidth, max(width, lbSize.width))
            height += lbSize.height
        }
        width += (self.contentEdge.left + self.contentEdge.right)
        height += (self.contentEdge.top + self.contentEdge.bottom)
        
        if minSize != nil {
            width = max(width, minSize!.width)
            height = max(height, minSize!.height)
        }
        return CGSize(width: width, height: height)
    }
    
    class func image(name : String) -> UIImage? {
        let resourceBundle : Bundle?
        let mainBundle = Bundle.init(for: self)
        let resourcePath = mainBundle.path(forResource: kRRRTipsResourceBundleName, ofType: "bundle")
        if resourcePath != nil {
            resourceBundle = Bundle(path: resourcePath!) ?? mainBundle
        }else{
            resourceBundle = mainBundle;
        }
        let image = UIImage(named: name, in: resourceBundle, compatibleWith: nil)
        return image
    }
    
}

private class RRRTipsBackgroundView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
}


private class RRRTipsCycleView: UIView {
    
    var cycleWidth : CGFloat = 5
    
    private lazy var grayLayer: CAShapeLayer = {
        let grayLayer = CAShapeLayer()
        grayLayer.frame = self.bounds
        grayLayer.lineWidth = cycleWidth
        grayLayer.fillColor = UIColor.clear.cgColor
        grayLayer.strokeColor = UIColor.gray.cgColor
        grayLayer.opacity = 1;
        grayLayer.lineCap = .round
        return grayLayer
    }()
    
    private lazy var progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        layer.lineWidth = cycleWidth
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.white.cgColor
        layer.opacity = 1;
        layer.lineCap = .round
        return layer
    }()
    
    override var center: CGPoint {
        didSet {
            let path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: self.frame.width / 2, startAngle: (-CGFloat.pi / 2), endAngle: (-CGFloat.pi / 2 + CGFloat.pi * 2), clockwise: true)
            self.grayLayer.path = path.cgPath
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RRRTipsCycleView{
    func setupViews() {
        self.layer.addSublayer(self.grayLayer)
        self.layer.addSublayer(self.progressLayer)
    }
    
    func updateProgress(_ progress : CGFloat) {
        let path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: self.frame.width / 2, startAngle: (-CGFloat.pi / 2), endAngle: (-CGFloat.pi / 2 + CGFloat.pi * 2 * progress), clockwise: true)
        self.progressLayer.path = path.cgPath
    }
    
}

