//
//  MessageListViewModel.swift
//  MessageList
//
//  Created by Richard Adem on 26/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import Foundation
import ReSwift
import RxSwift
import RxDataSources

class MessageListViewModel {
    
    // MARK: - Observable vars
    
    let content = Variable<[MessageListSectionPresenter]>([])
    let isLoading = Variable<Bool>(false)
    // MARK: Placeholder content
    
//    private static var sections: [MessageListSectionPresenter] = [
//        MessageListSectionPresenter(title: "Top", items: [
//            MessageListItemPresenter(title: "hello", iconCharacter: "A"),
//            MessageListItemPresenter(title: "hi", iconCharacter: "b"),
//        ])
//    ]
    
    // MARK: - Properties
    fileprivate var disposeBag = DisposeBag()
    
    
    required init() {
        store.subscribe(self)
        
        store.dispatch(MessagesAction.fetch)
    }
    
    // MARK: Public fuctions
    
    func tableDidReachNearEnd() {
        isLoading.value = true
        
        store.dispatch(MessagesAction.fetch)
    }
}

extension MessageListViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = State
    
    func newState(state: StoreSubscriberStateType) {
        if state.messagesState.messages.messages.count > 0 {
            
            content.value = [MessageListSectionPresenter(title: "Top", items:
                state.messagesState.messages.messages.map { message in
                    MessageListItemPresenter(title: message.author.name,
                                             subTitle: "\(message.updated)", // TODO: format this here
                                             iconImageUrl: message.author.photoUrl,
                                             content: message.content)
                    
                }
            )]
            isLoading.value = false
        } else {
            print("no messages yet")
            isLoading.value = true
        }
    }
}
