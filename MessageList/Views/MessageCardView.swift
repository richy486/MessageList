//
//  MessageCardView.swift
//  MessageList
//
//  Created by Richard Adem on 28/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import UIKit

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
    
    let backgroundView: UIView = {
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
    
    let iconImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // If this is a rectangle, lets make this a round rect instead of a circle
        view.layer.cornerRadius = min(LayoutConstants.authorImageSize.width, LayoutConstants.authorImageSize.height)/2
        view.clipsToBounds = true
        return view
    }()
    
    // TODO: Fix type styles
    let headingLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let subTitleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let contentLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.numberOfLines = 0
        return view
    }()
    
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
            
            headingLabel.topAnchor.constraint(equalTo: topAnchor, constant: LayoutConstants.viewInsets.top),
            headingLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: Constants.LayoutConstants.spacing),
            headingLabel.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -Constants.LayoutConstants.spacing),
            
            subTitleLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor),
            subTitleLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: Constants.LayoutConstants.spacing),
            subTitleLabel.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -Constants.LayoutConstants.spacing),
            
            contentLabel.topAnchor.constraint(greaterThanOrEqualTo: subTitleLabel.bottomAnchor, constant: Constants.LayoutConstants.spacing),
            contentLabel.topAnchor.constraint(greaterThanOrEqualTo: iconImageView.bottomAnchor, constant: Constants.LayoutConstants.spacing),
            contentLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: Constants.LayoutConstants.spacing),
            contentLabel.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -Constants.LayoutConstants.spacing),
            contentLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -Constants.LayoutConstants.spacing)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
