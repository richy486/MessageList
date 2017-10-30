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
                                             left: Constants.Layout.spacing,
                                             bottom: 8,
                                             right: Constants.Layout.spacing)
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
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(cardView)
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
    
    // MARK: Private methods
    
    // MARK: Public methods
    
    func setup(withPresenter presenter: MessageListItemPresenter) {
        
        self.cardView.transform = .identity
        
        cardView.heading = presenter.heading
        cardView.subTitle = presenter.subTitle
        cardView.iconImageURL = presenter.iconImageUrl
        cardView.content = presenter.content
        
        disposeBag = DisposeBag()
        setupSwipePan(withView: cardView) { [weak self] in
            self?.dismissed.onNext(())
        }.disposed(by: disposeBag)
    }
}
