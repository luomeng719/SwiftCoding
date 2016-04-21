//
//  BOAlertView.swift
//  CustomAlertView
//
//  Created by luomeng on 16/4/21.
//  Copyright © 2016年 luomeng. All rights reserved.
//

import UIKit

class BOAlertView: UIView {

    private var alertTitleLabel: UILabel!
    private var alertContentLabel: UILabel!
    private var leftBtn: UIButton!
    private var rightBtn: UIButton!
    lazy private var backgroundView: UIView = UIView.init()
    
    // MARK: constant
    private let kAlertWidth: CGFloat = 245.0
    private let kAlertHeight: CGFloat = 160.0
    private let kTitleYOffset: CGFloat = 15.0
    private let kTitleHeight: CGFloat = 25.0
    private let kContentOffset: CGFloat = 30.0
    private let kContentWidth: CGFloat = 230.0
    private let kBetweenLabelOffset: CGFloat = 20.0
    private var _leftLeave = false
    
    // MARK: public propertity
    var leftBlock: dispatch_block_t!
    var rightBlock: dispatch_block_t!
    var dismissBlock: dispatch_block_t!
    
    override init(frame: CGRect) {
        alertTitleLabel = UILabel.init()
        alertContentLabel = UILabel.init()
        leftBtn = UIButton.init()
        rightBtn = UIButton.init()
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String?, contentText: String?, leftTitle: String?, rightTitle: String?) {
        self.init(frame: CGRectZero)
        
        self.setUPUI(title, contentText: contentText, leftTitle: leftTitle, rightTitle: rightTitle)
        self.layer.cornerRadius = 5.0
    }
    
    private func setUPUI(title: String?, contentText: String?, leftTitle: String?, rightTitle: String?) {
        self.backgroundColor = UIColor.whiteColor()
        self.alertTitleLabel.font = UIFont.boldSystemFontOfSize(20)
        self.alertTitleLabel.frame = CGRectMake(0, kTitleYOffset, kAlertWidth, kTitleHeight)
        self.alertTitleLabel.textColor = UIColor.init(colorLiteralRed: 56.0/255, green: 64.0/255, blue: 71.0/255, alpha: 1)
        self.alertTitleLabel.textAlignment = .Center
        self.addSubview(self.alertTitleLabel)
        
        self.alertContentLabel.frame = CGRectMake((kAlertWidth - kContentWidth) * 0.5, CGRectGetMaxY(self.alertTitleLabel.frame), kContentWidth, 60)
        self.alertContentLabel.numberOfLines = 0
        self.alertContentLabel.textAlignment = .Center
        self.alertContentLabel.textColor = UIColor.init(red: 127.0/255, green: 127.0/255, blue: 127.0/255, alpha: 1)
        self.alertContentLabel.font = UIFont.systemFontOfSize(15)
        self.addSubview(self.alertContentLabel)
        
        let kSingleBtnWidth: CGFloat = 160.0
        let kCoupleBtnWidth: CGFloat = 107.0
        let kBtnHeight: CGFloat = 40.0
        let kBtnBottomOffset: CGFloat = 10.0
        
        var leftBtnFrame: CGRect!
        var rightBtnFrame: CGRect!
        if leftTitle == nil {
            rightBtnFrame = CGRectMake((self.kAlertWidth - kSingleBtnWidth) * 0.5, kAlertHeight - kBtnBottomOffset - kBtnHeight, kSingleBtnWidth, kBtnHeight)
            self.rightBtn = UIButton.init(type: .Custom)
            self.rightBtn.frame = rightBtnFrame
        } else {
            leftBtnFrame = CGRectMake((kAlertWidth - 2 * kCoupleBtnWidth - kBtnBottomOffset) * 0.5, kAlertHeight - kBtnBottomOffset - kBtnHeight, kCoupleBtnWidth, kBtnHeight);
            rightBtnFrame = CGRectMake(CGRectGetMaxX(leftBtnFrame) + (kBtnBottomOffset), kAlertHeight - kBtnBottomOffset - kBtnHeight, kCoupleBtnWidth, kBtnHeight);
            self.leftBtn = UIButton.init(type: .Custom)
            self.rightBtn = UIButton.init(type: .Custom)
            self.leftBtn.frame = leftBtnFrame
            self.rightBtn.frame = rightBtnFrame
        }
        
        self.rightBtn.backgroundColor = UIColor.init(red: 0.0, green: 0.72, blue: 0.7, alpha: 1)
        self.leftBtn.backgroundColor = UIColor.init(red: 252.0/255, green: 61.0/255, blue: 92.0/255, alpha: 1)
        self.rightBtn.setTitle(rightTitle, forState: .Normal)
        self.leftBtn.setTitle(leftTitle, forState: .Normal)
        self.leftBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
        self.rightBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
        self.leftBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.rightBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        self.leftBtn.addTarget(self, action: #selector(leftBtnClicked(_:)), forControlEvents: .TouchUpInside)
        self.rightBtn.addTarget(self, action: #selector(rightBtnClicked(_:)), forControlEvents: .TouchUpInside)
        
        self.addSubview(self.leftBtn)
        self.addSubview(self.rightBtn)
        
        self.alertTitleLabel.text = title
        self.alertContentLabel.text = contentText
    }
    
    func showAlertView() {
        let sharedWindow = UIApplication.sharedApplication().keyWindow
        self.frame = CGRectMake((CGRectGetWidth(sharedWindow!.bounds) - kAlertWidth) * 0.5, -kAlertHeight - 30, kAlertWidth,kAlertHeight);
        sharedWindow?.addSubview(self)
    }
    
    // MARK: Btn Action
    @objc private func leftBtnClicked(sender: UIButton) {
        _leftLeave = true
        self.dismissAlert()
        if let theLeftBlock = leftBlock {
            theLeftBlock()
        }
    }
    
    @objc private func rightBtnClicked(sender: UIButton) {
        _leftLeave = false
        self.dismissAlert()
        if let theRightBlock = rightBlock {
            theRightBlock()
        }
    }
    
    private func dismissAlert() {
        self.removeFromSuperview()
        if let theDismissBlock = dismissBlock {
            theDismissBlock()
        }
    }
    
    // MARK: override
    override func willMoveToSuperview(newSuperview: UIView?) {
        if let theSuperView = newSuperview {
            let sharedWindow = UIApplication.sharedApplication().keyWindow
            
            self.backgroundView.frame = (sharedWindow?.bounds)!
            self.backgroundView.backgroundColor = UIColor.grayColor()
            self.backgroundView.alpha = 0.6
            sharedWindow?.addSubview(self.backgroundView)
            self.transform = CGAffineTransformMakeRotation((CGFloat)(-M_1_PI / 2))
            let afterFrame = CGRectMake((CGRectGetWidth((sharedWindow?.bounds)!) - kAlertWidth) * 0.5, (CGRectGetHeight((sharedWindow?.bounds)!) - kAlertHeight) * 0.5, kAlertWidth, kAlertHeight);
            
            UIView.animateWithDuration(0.35, delay: 0.0, options: .CurveEaseInOut, animations: {
                self.transform = CGAffineTransformMakeRotation(0)
                self.frame = afterFrame
                }, completion: { (finished) in
                    
            })
            super.willMoveToSuperview(theSuperView)
        }
    }
    
    override func removeFromSuperview() {
        self.backgroundView.removeFromSuperview()
        let sharedWindow = UIApplication.sharedApplication().keyWindow
        let afterFrame = CGRectMake((CGRectGetWidth(sharedWindow!.bounds) - kAlertWidth) * 0.5, CGRectGetHeight(sharedWindow!.bounds), kAlertWidth, kAlertHeight);
        
        UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveEaseInOut, animations: { 
            self.frame = afterFrame
            if self._leftLeave {
                self.transform = CGAffineTransformMakeRotation((CGFloat)(-M_1_PI / 1.5))
            } else {
                self.transform = CGAffineTransformMakeRotation((CGFloat)(M_1_PI) / 1.5)
            }
        }) { (finished) in
              super.removeFromSuperview()
        }
    }
}
