//
//  MessageCell.swift
//  MessageList
//
//  Created by Richard Adem on 28/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture

class MessageCell: UITableViewCell, SwipePan {
    
    // MARK: - Layout constants
    
    private struct LayoutConstants {
        static let viewInsets = UIEdgeInsets(top: 0,
                                             left: Constants.LayoutConstants.spacing,
                                             bottom: 8,
                                             right: Constants.LayoutConstants.spacing)
//        static let authorImageSize = CGSize(width: 40, height: 40)
        
    }
    
    // MARK: - Subviews
    
    let cardView: MessageCardView = {
        let view = MessageCardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    let dismissed = PublishSubject<Void>()
//    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
//    self.originalBounds = self.image.bounds;
//    self.originalCenter = self.image.center;
//    private var originalBounds = CGRect.zero
//    private var originalCenter = CGPoint.zero
//    private lazy var animator: UIDynamicAnimator = {
//        return UIDynamicAnimator(referenceView: cardView)
//    }()
//    var lastTime = CFAbsoluteTime()
//    var lastAngle: CGFloat = 0.0
//    var angularVelocity: CGFloat = 0.0
//    var attachment : UIAttachmentBehavior?
    
//    var originalPosition = CGPoint.zero
//    var originalTransform = CGAffineTransform.identity
    
    // MARK: - View lifecycle
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(cardView) // TODO: Fix up tapped state
//        backgroundView = cardView
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: topAnchor, constant: LayoutConstants.viewInsets.top),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -LayoutConstants.viewInsets.bottom),

            cardView.leftAnchor.constraint(equalTo: leftAnchor, constant: LayoutConstants.viewInsets.left),
            cardView.rightAnchor.constraint(equalTo: rightAnchor, constant: -LayoutConstants.viewInsets.right),
        ])
        
//        cardView.initSwipeToDismissView(self)
        
//        originalBounds = cardView.bounds
        
        
        
        
//        let panGesture = cardView.rx.panGesture().share(replay: 1)
//
//        panGesture
//            .when(.began)
//            .subscribe(onNext: { [unowned self] gesture in
//                self.animator.removeAllBehaviors()
//
//                guard let gestureView = gesture.view else {
//                    return
//                }
//                guard let superView = gestureView.superview else {
//                    return
//                }
//
//                self.originalCenter = gestureView.center
//
//                let location = gesture.location(in: superView.superview!)
////                let velocity = gesture.velocity(in: superView)
//
////                [[UIAttachmentBehavior alloc] initWithItem:card offsetFromCenter:UIOffsetMake(location.x - card.center.x, location.y - card.center.y) attachedToAnchor:location];
//                //[self attachCard:topCard ToPoint:location];
////                let offset = UIOffsetMake(location.x - gestureView.center.x, location.y - gestureView.center.y)
////                let offset = UIOffsetMake(0, 0)
////                self.attachment = UIAttachmentBehavior(item: gestureView,
////                                                       offsetFromCenter: offset,
////                                                       attachedToAnchor: location)
////                [self.animator addBehavior:self.attachment];
//
//                self.attachment = UIAttachmentBehavior(item: gestureView, attachedToAnchor: location)
//
//                guard let attachment = self.attachment else {
//                    return
//                }
//                self.animator.addBehavior(attachment)
//
//
//
//
////                self.originalCenter = gestureView.center
////                let pointWithinAnimatedView = gesture.location(in: gestureView)
////                let offset = UIOffsetMake(pointWithinAnimatedView.x - gestureView.bounds.size.width / 2.0, pointWithinAnimatedView.y - gestureView.bounds.size.height / 2.0)
////                let offset = UIOffsetMake(pointWithinAnimatedView.x - gestureView.bounds.size.width / 2.0,
////                                          pointWithinAnimatedView.y - gestureView.bounds.size.height / 2.0)
//
////                let offset = UIOffsetMake(0, 0)
////
////                let anchor = gesture.location(in: gestureView.superview!)
////
////                // create attachment behavior
////                self.attachment = UIAttachmentBehavior(item: gestureView,
////                                                       offsetFromCenter: offset,
////                                                       attachedToAnchor: anchor)
//
////                // code to calculate angular velocity (seems curious that I have to calculate this myself, but I can if I have to)
////                self.lastTime = CFAbsoluteTimeGetCurrent()
////                self.lastAngle = self.angleOf(gestureView)
////
////                self.attachment?.action = { [unowned self] () -> Void in
////                    let time = CFAbsoluteTimeGetCurrent()
////                    let angle: CGFloat = self.angleOf(gestureView)
////                    if time > self.lastTime {
////                        self.angularVelocity = (angle - self.lastAngle) / CGFloat(time - self.lastTime)
////                        self.lastTime = time
////                        self.lastAngle = angle
////                    }
////                }
////                self.animator.addBehavior(self.attachment!)
//            })
//            .disposed(by: disposeBag)
//
//        panGesture
//            .when(.changed)
//            .subscribe(onNext: { [unowned self] gesture in
//
//                guard let gestureView = gesture.view else {
//                    return
//                }
//                guard let superView = gestureView.superview else {
//                    return
//                }
//                let location = gesture.location(in: superView)
////                let velocity = gesture.velocity(in: superView)
////
////                let anchor = gesture.location(in: superView)
////                self.attachment?.anchorPoint = anchor
//                self.attachment?.anchorPoint = location
////                [self showLeftOrRightViewsOnCard:topCard];
//
//            })
//            .disposed(by: disposeBag)
//
//        panGesture
//            .when(.ended)
//            .subscribe(onNext: { [unowned self] gesture in
//                guard let gestureView = gesture.view else {
//                    return
//                }
//
//                guard let superView = gestureView.superview else {
//                    return
//                }
//                let location = gesture.location(in: superView)
//                let velocity = gesture.velocity(in: superView)
//
//                self.animator.removeAllBehaviors()
//                let snap = UISnapBehavior(item: gestureView, snapTo: self.originalCenter)
//                self.animator.addBehavior(snap)
//
////                let velocity = gesture.velocity(in: superView) //[gesture velocityInView:gesture.view.superview];
////
////                // if we aren't dragging it down, just snap it back and quit
////                let pi2 = CGFloat(Double.pi / 2)
////                let pi4 = CGFloat(Double.pi / 4)
//////                if fabs(atan2(velocity.y, velocity.x) - pi2) > pi4 {
//////                    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:gesture.view snapToPoint:startCenter];
//////                    [self.animator addBehavior:snap];
////                    let snap = UISnapBehavior(item: gestureView, snapTo: self.originalCenter)
////                    self.animator.addBehavior(snap)
//////                    return
//////                }
//
////                let anchor = gesture.location(in: gestureView.superview!)
////                self.attachment?.anchorPoint = anchor
////                self.animator.removeAllBehaviors()
////                let velocity = gesture.velocity(in: gestureView.superview!)
////                let dynamic = UIDynamicItemBehavior(items: [gestureView])
////                dynamic.addLinearVelocity(velocity, for: gestureView)
////                dynamic.addAngularVelocity(self.angularVelocity, for: gestureView)
////                dynamic.angularResistance = 1.25
////
////                // when the view no longer intersects with its superview, go ahead and remove it
////                dynamic.action = { [unowned self] () -> Void in
////                    if !gestureView.superview!.bounds.intersects(gestureView.frame) {
////                        self.animator.removeAllBehaviors()
////                        gesture.view?.removeFromSuperview()
////                    }
////                }
////
////                self.animator.addBehavior(dynamic)
//
////                let gravity = UIGravityBehavior(items: [gestureView])
////                gravity.magnitude = 0.7
////                self.animator.addBehavior(gravity)
//            })
//            .disposed(by: disposeBag)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Private methods
    
//    private func setupPanGesture() {
//        let panGesture = cardView.rx.panGesture().share(replay: 1)
//
//        panGesture
//            .when(.began)
//            .subscribe(onNext: { [unowned self] _ in
////                self.originalPosition = self.cardView.center
////                self.originalTransform = self.cardView.transform
//            })
//            .disposed(by: disposeBag)
//
//        panGesture
//            .when(.changed)
//            .asTranslation()
//            .subscribe(onNext: { [unowned self] translation, _ in
//                self.cardView.transform = CGAffineTransform(translationX: translation.x, y: 0)
////                self.cardView.center.x = self.originalPosition.x + translation.x
//            })
//            .disposed(by: disposeBag)
//
//        panGesture
//            .when(.ended)
//            .subscribe(onNext: { [unowned self] gesture in
//
//                print("\(self.cardView.transform)")
////                CGAffineTransform.translatedBy(<#T##CGAffineTransform#>)
////                if self.cardView.center.x - self.originalPosition.x > self.originalPosition.x {
//                if self.cardView.transform.tx > self.cardView.frame.width/2 {
//                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9, options: .curveEaseInOut, animations: {
////                        self.cardView.center = CGPoint(x: self.originalPosition.x * 3, y: self.originalPosition.y )
//                        self.cardView.transform = CGAffineTransform(translationX: self.cardView.frame.width * 3, y: 0)
//                    }, completion: { _ in
//                        self.dismissed.onNext(())
//                    })
//                } else {
////
//                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9, options: .curveEaseInOut, animations: {
////                        self.cardView.center = self.originalPosition
//                        self.cardView.transform = CGAffineTransform.identity//self.originalTransform
//                    }, completion: nil)
//                }
//            })
//            .disposed(by: disposeBag)
//    }
    
    
    
    
//    private func angleOf(_ view: UIView) -> CGFloat {
//        return atan2(view.transform.b, view.transform.a)
//    }
//
//    - (UIAttachmentBehavior*)attachCard:(UIView*)card ToPoint:(CGPoint)location {
//    return [[UIAttachmentBehavior alloc] initWithItem:card offsetFromCenter:UIOffsetMake(location.x - card.center.x, location.y - card.center.y) attachedToAnchor:location];
//    }
    
//    func attach(card: )
    
    // MARK: Public methods
    
    func setup(withPresenter presenter: MessageListItemPresenter) {
        
        self.cardView.transform = .identity
        
        cardView.heading = "\(presenter.id) \(presenter.heading)"//presenter.heading
        cardView.subTitle = presenter.subTitle
        cardView.iconImageURL = presenter.iconImageUrl
        cardView.content = presenter.content
        
        disposeBag = DisposeBag()
        setupSwipePan(withView: cardView) { [weak self] in
            self?.dismissed.onNext(())
        }.disposed(by: disposeBag)
    }
}
