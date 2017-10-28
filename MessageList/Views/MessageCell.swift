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
        static let viewInsets = UIEdgeInsets(top: 4,
                                             left: Constants.LayoutConstants.spacing,
                                             bottom: 4,
                                             right: Constants.LayoutConstants.spacing)
//        static let authorImageSize = CGSize(width: 40, height: 40)
        
    }
    
    // MARK: - Subviews
    
    let cardView: MessageCardView = {
        let view = MessageCardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    
//    let iconImageView: UIImageView = {
//        let view = UIImageView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    let headingLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.backgroundColor = .white
//        return label
//    }()
    
    // MARK: - Properties
    
    // MARK: - View lifecycle
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        addSubview(cardView)
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
        
        cardView.headingLabel.text = presenter.heading
        cardView.subTitleLabel.text = presenter.subTitle
        cardView.iconImageView.sd_setImage(with: presenter.iconImageUrl)
        cardView.contentLabel.text = presenter.content
    }
}
