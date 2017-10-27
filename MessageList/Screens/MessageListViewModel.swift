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
    
    let content = Observable.just(MessageListViewModel.sections)
    
    // MARK: Placeholder content
    
    private static var sections: [MessageListSectionPresenter] = [
        MessageListSectionPresenter(title: "Top", items: [
            MessageListItemPresenter(title: "hello", iconCharacter: "A"),
            MessageListItemPresenter(title: "hi", iconCharacter: "b"),
        ])
    ]
    
    // MARK: - Properties
    fileprivate var disposeBag = DisposeBag()
    
    
    required init() {
        store.subscribe(self)
        
        store.dispatch(fetchMesages)
    }
}

extension MessageListViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = State
    
    func newState(state: StoreSubscriberStateType) {
        
    }
}
