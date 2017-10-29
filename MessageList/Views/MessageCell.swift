//
//  MessageCell.swift
//  MessageList
//
//  Created by Richard Adem on 28/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
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
    
    // MARK: - View lifecycle
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        addSubview(cardView) // TODO: Fix up tapped state
//        backgroundView = cardView
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: topAnchor, constant: LayoutConstants.viewInsets.top),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -LayoutConstants.viewInsets.bottom),

            cardView.leftAnchor.constraint(equalTo: leftAnchor, constant: LayoutConstants.viewInsets.left),
            cardView.rightAnchor.constraint(equalTo: rightAnchor, constant: -LayoutConstants.viewInsets.right),
        ])

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Public methods
    
    func setup(withPresenter presenter: MessageListItemPresenter) {
        
        cardView.heading = presenter.heading
        cardView.subTitle = presenter.subTitle
        cardView.iconImageURL = presenter.iconImageUrl
        cardView.content = presenter.content
    }
}
