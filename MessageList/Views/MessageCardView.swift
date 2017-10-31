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
        static let viewInsets = UIEdgeInsets(top: Constants.Layout.spacing,
                                             left: Constants.Layout.spacing,
                                             bottom: Constants.Layout.spacing,
                                             right: Constants.Layout.spacing)
        static let authorImageSize = CGSize(width: 40, height: 40)
        
    }
    
    // MARK: - Subviews
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds = false
        view.layer.shadowColor = Constants.Layout.shadowColor.cgColor
        view.layer.shadowOpacity = Float(Constants.Layout.shadowOpacity)
        view.layer.shadowRadius = Constants.Layout.shadowRadius
        view.layer.shadowOffset = Constants.Layout.shadowOffset
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
        view.numberOfLines = 4 // This is the limit in the design mockups
        view.adjustsFontSizeToFitWidth = false
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
            paragraphStyle.lineBreakMode = .byTruncatingTail
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
            headingLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: Constants.Layout.spacing),
            headingLabel.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -Constants.Layout.spacing),
            
            subTitleLabel.topAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            subTitleLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: Constants.Layout.spacing),
            subTitleLabel.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -Constants.Layout.spacing),
            
            contentLabel.topAnchor.constraint(greaterThanOrEqualTo: subTitleLabel.bottomAnchor, constant: Constants.Layout.spacing),
            contentLabel.topAnchor.constraint(greaterThanOrEqualTo: iconImageView.bottomAnchor, constant: Constants.Layout.spacing),
            contentLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.Layout.spacing),
            contentLabel.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -Constants.Layout.spacing),
            contentLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -Constants.Layout.spacing)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var animator : UIDynamicAnimator?
    private var originalCenter = CGPoint.zero
    private var attachment : UIAttachmentBehavior?
}
