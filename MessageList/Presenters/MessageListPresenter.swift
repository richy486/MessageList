//
//  MessageListPresenter.swift
//  MessageList
//
//  Created by Richard Adem on 26/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import RxDataSources

typealias MessageListSectionModel = SectionModel<MessageListSectionPresenter, MessageListSectionPresenter>


// MARK: Item

struct MessageListItemPresenter {
    let title: String
    let subTitle: String
    let iconImageUrl: URL
    let content: String
    
    let id: Int
}

extension MessageListItemPresenter: IdentifiableType, Equatable {
    typealias Identity = Int
    
    var identity : Identity { return self.id }
}

func ==(lhs: MessageListItemPresenter, rhs: MessageListItemPresenter) -> Bool {
    return lhs.id == rhs.id
}

// MARK: Section

struct MessageListSectionPresenter {
    
    let title: String
    var items: [Item]
    
    let id: Int
}

func ==(lhs: MessageListSectionPresenter, rhs: MessageListSectionPresenter) -> Bool {
    return lhs.id == rhs.id
}

extension MessageListSectionPresenter: AnimatableSectionModelType {
    typealias Item = MessageListItemPresenter
    typealias Identity = Int
    
    var identity : Identity { return self.id }
    
    public init(original: MessageListSectionPresenter, items: [MessageListSectionPresenter.Item]) {
        self = original
        self.items = items
    }
}
