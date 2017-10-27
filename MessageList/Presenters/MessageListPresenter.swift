//
//  MessageListPresenter.swift
//  MessageList
//
//  Created by Richard Adem on 26/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import RxDataSources

typealias MessageListSectionModel = SectionModel<MessageListSectionPresenter, MessageListSectionPresenter>

struct MessageListSectionPresenter {
    
    let title: String
    var items: [Item]
}

extension MessageListSectionPresenter: SectionModelType {
    typealias Item = MessageListItemPresenter
    
    public init(original: MessageListSectionPresenter, items: [MessageListSectionPresenter.Item]) {
        self = original
        self.items = items
    }
}

struct MessageListItemPresenter {
    let title: String
    let iconCharacter: Character
}
