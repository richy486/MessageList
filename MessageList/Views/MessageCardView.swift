//
//  MessageCardView.swift
//  MessageList
//
//  Created by Richard Adem on 28/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import UIKit
import SDWebImage

class MessageCardView: UIView {

    // MARK: - Layout constants
    
    private struct LayoutConstants {
        static let viewInsets = UIEdgeInsets(top: Constants.LayoutConstants.spacing,
                                             left: Constants.LayoutConstants.spacing,
                                             bottom: Constants.LayoutConstants.spacing,
                                             right: Constants.LayoutConstants.spacing)
        static let authorImageSize = CGSize(width: 40, height: 40)
        
    }
    
    // MARK: - Subviews
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.27
        view.layer.shadowRadius = 2
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shouldRasterize = true
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // If this is a rectangle, lets make this a round rect instead of a circle
        view.layer.cornerRadius = min(LayoutConstants.authorImageSize.width, LayoutConstants.authorImageSize.height)/2
        view.clipsToBounds = true
        return view
    }()
    
    // TODO: Fix type styles
    private let headingLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return view
    }()
    
    private let subTitleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return view
    }()
    
    private let contentLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.numberOfLines = 0 // TODO: should we limit the text to 4 lines like the mock up?
        return view
    }()
    
    var iconImageURL: URL? {
        get {
            return iconImageView.sd_imageURL()
        }
        set {
            iconImageView.sd_setImage(with: newValue)
        }
    }
    
    var heading: String? {
        get {
            return headingLabel.text
        }
        set {
            headingLabel.text = newValue
        }
    }
    
    var subTitle: String? {
        get {
            return subTitleLabel.text
        }
        set {
            subTitleLabel.text = newValue
        }
    }
    
    // Breaking out these properties so we can do additional text stying via the `attributedText` property
    var content: String? {
        get {
            return contentLabel.attributedText?.string
        }
        set {
            guard let newValue = newValue else {
                contentLabel.attributedText = NSAttributedString(string: "")
                return
            }
            let paragraphStyle = NSMutableParagraphStyle()
            
            // Estimated as iOS calculates the line spacing differently than Photoshop
            paragraphStyle.lineSpacing = 2
            contentLabel.attributedText = NSAttributedString(string: newValue,
                                                             attributes: [NSAttributedStringKey.paragraphStyle: paragraphStyle])
        }
    }
    
    // MARK: - Properties
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backgroundView)
        addSubview(iconImageView)
        addSubview(headingLabel)
        addSubview(subTitleLabel)
        addSubview(contentLabel)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundView.leftAnchor.constraint(equalTo: leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: rightAnchor),
            
            
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: LayoutConstants.viewInsets.top),
            iconImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: LayoutConstants.viewInsets.left),
            iconImageView.widthAnchor.constraint(equalToConstant: LayoutConstants.authorImageSize.width),
            iconImageView.heightAnchor.constraint(equalToConstant: LayoutConstants.authorImageSize.height),
            
            headingLabel.bottomAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            headingLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: Constants.LayoutConstants.spacing),
            headingLabel.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -Constants.LayoutConstants.spacing),
            
            subTitleLabel.topAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            subTitleLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: Constants.LayoutConstants.spacing),
            subTitleLabel.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -Constants.LayoutConstants.spacing),
            
            contentLabel.topAnchor.constraint(greaterThanOrEqualTo: subTitleLabel.bottomAnchor, constant: Constants.LayoutConstants.spacing),
            contentLabel.topAnchor.constraint(greaterThanOrEqualTo: iconImageView.bottomAnchor, constant: Constants.LayoutConstants.spacing),
            contentLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.LayoutConstants.spacing),
            contentLabel.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -Constants.LayoutConstants.spacing),
            contentLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -Constants.LayoutConstants.spacing)
        ])
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var animator : UIDynamicAnimator?
    private var originalCenter = CGPoint.zero
    private var attachment : UIAttachmentBehavior?
}

extension MessageCardView {
    
    func initSwipeToDismissView(_ parentView:UIView)  {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(draggingGesture))
        self.addGestureRecognizer(panGesture)
        animator = UIDynamicAnimator(referenceView: parentView)
        
    }
    
    @objc func draggingGesture(_ gesture:UIPanGestureRecognizer)  {
        
//        var lastTime = CFAbsoluteTime()
//        var lastAngle: CGFloat = 0.0
//        var angularVelocity: CGFloat = 0.0
        
        if gesture.state == .began {
//            self.animator?.removeAllBehaviors()
//            if let gestureView = gesture.view {
//                let pointWithinAnimatedView = gesture.location(in: gestureView)
//                let offset = UIOffsetMake(pointWithinAnimatedView.x - gestureView.bounds.size.width / 2.0, pointWithinAnimatedView.y - gestureView.bounds.size.height / 2.0)
//                let anchor = gesture.location(in: gestureView.superview!)
//                // create attachment behavior
//                attachment = UIAttachmentBehavior(item: gestureView, offsetFromCenter: offset, attachedToAnchor: anchor)
//                // code to calculate angular velocity (seems curious that I have to calculate this myself, but I can if I have to)
//                lastTime = CFAbsoluteTimeGetCurrent()
//                lastAngle = self.angleOf(gestureView)
//                weak var weakSelf = self
//                attachment?.action = {() -> Void in
//                    let time = CFAbsoluteTimeGetCurrent()
//                    let angle: CGFloat = weakSelf!.angleOf(gestureView)
//                    if time > lastTime {
//                        angularVelocity = (angle - lastAngle) / CGFloat(time - lastTime)
//                        lastTime = time
//                        lastAngle = angle
//                    }
//                }
//                self.animator?.addBehavior(attachment!)
//            }
            
            self.animator?.removeAllBehaviors()
            guard let gestureView = gesture.view else {
                return
            }
            guard let superView = gestureView.superview else {
                return
            }
            self.originalCenter = gestureView.center
            let location = gesture.location(in: gestureView)
            
            
//            let offset = UIOffsetMake(location.x - gestureView.bounds.size.width / 2.0,
//                                      location.y - gestureView.bounds.size.height / 2.0)
            let offset = UIOffsetMake(location.x - gestureView.center.x, location.y - gestureView.center.y)
//            let offset = UIOffsetMake(0, 0)

            let anchor = gesture.location(in: superView)

            // create attachment behavior
            attachment = UIAttachmentBehavior(item: gestureView,
                                                   offsetFromCenter: offset,
                                                   attachedToAnchor: anchor)
//            attachment = UIAttachmentBehavior.slidingAttachment(with: gestureView, attachedTo: superView, attachmentAnchor: anchor, axisOfTranslation: CGVector(dx: 1, dy: 0))
            
//            attachment.action = {
//                if (!limitVerticalMovement) return;
//
//                CGPoint center = item.center;
//                center.y = staticCenterY;
//                item.center = center;
//            }
            
            let staticCenterY = location.y;
            attachment?.action = {
                var center = gestureView.center
                center.y = staticCenterY
                gestureView.center = center
            }
            
            self.animator?.addBehavior(attachment!)
            
        }
        else if gesture.state == .changed {
//            if let gestureView = gesture.view {
//                if let superView = gestureView.superview {
//                    let anchor = gesture.location(in: superView)
//                    if let attachment = attachment {
//                        attachment.anchorPoint = anchor
//                    }
//                }
//            }
            
                guard let gestureView = gesture.view else {
                    return
                }
                guard let superView = gestureView.superview else {
                    return
                }
                let location = gesture.location(in: superView)
//                let velocity = gesture.velocity(in: superView)
//
//                let anchor = gesture.location(in: superView)
//                self.attachment?.anchorPoint = anchor
                attachment?.anchorPoint = CGPoint(x: location.x, y: self.originalCenter.y)
//                [self showLeftOrRightViewsOnCard:topCard];
        }
        else if gesture.state == .ended {
//            if let gestureView = gesture.view {
//                let anchor = gesture.location(in: gestureView.superview!)
//                attachment?.anchorPoint = anchor
//                self.animator?.removeAllBehaviors()
//                let velocity = gesture.velocity(in: gestureView.superview!)
//                let dynamic = UIDynamicItemBehavior(items: [gestureView])
//                dynamic.addLinearVelocity(velocity, for: gestureView)
//                dynamic.addAngularVelocity(angularVelocity, for: gestureView)
//                dynamic.angularResistance = 1.25
//                // when the view no longer intersects with its superview, go ahead and remove it
//                weak var weakSelf = self
//                dynamic.action = {() -> Void in
//                    if !gestureView.superview!.bounds.intersects(gestureView.frame) {
//                        weakSelf?.animator?.removeAllBehaviors()
//                        gesture.view?.removeFromSuperview()
//                    }
//                }
//                self.animator?.addBehavior(dynamic)
//
//                let gravity = UIGravityBehavior(items: [gestureView])
//                gravity.magnitude = 0.7
//                self.animator?.addBehavior(gravity)
//            }
            
            guard let gestureView = gesture.view else {
                return
            }
            guard let superView = gestureView.superview else {
                return
            }
            let location = gesture.location(in: gestureView)
            
            
            let offset = CGPoint(x: location.x - gestureView.bounds.size.width / 2.0,
                                 y: location.y - gestureView.bounds.size.height / 2.0)
            
            if let attachment = attachment {
                self.animator?.removeBehavior(attachment)
            }
            let snap = UISnapBehavior(item: gestureView, snapTo: self.originalCenter)
            snap.damping = 1
            self.animator?.addBehavior(snap)
        }
    }
    
    func angleOf(_ view: UIView) -> CGFloat {
        return atan2(view.transform.b, view.transform.a)
    }
}
