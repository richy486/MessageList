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
        static let spacing = CGFloat(16)
        static let viewInsets = UIEdgeInsets(top: LayoutConstants.spacing,
                                             left: LayoutConstants.spacing,
                                             bottom: LayoutConstants.spacing,
                                             right: LayoutConstants.spacing)
        static let authorImageSize = CGSize(width: 40, height: 40)
        
    }
    
    // MARK: - Subviews
    
    let authorImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties
    
    // MARK: - View lifecycle
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(authorImageView)
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            authorImageView.topAnchor.constraint(equalTo: topAnchor, constant: LayoutConstants.viewInsets.top),
            authorImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: LayoutConstants.viewInsets.left),
            authorImageView.widthAnchor.constraint(equalToConstant: LayoutConstants.authorImageSize.width),
            authorImageView.heightAnchor.constraint(equalToConstant: LayoutConstants.authorImageSize.height),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: LayoutConstants.viewInsets.top),
            titleLabel.leftAnchor.constraint(equalTo: authorImageView.rightAnchor, constant: LayoutConstants.spacing),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -LayoutConstants.spacing),
            
            authorImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50), // TODO: add the rest of the views
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
        
        
    }

}
