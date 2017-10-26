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

class MessageListViewModel {
    
    // MARK: - Observable vars
    // TODO: replace with localised string
    let title = Variable<String>("Message List")
    
    // MARK: - Properties
    fileprivate var disposeBag = DisposeBag()
    
    required init() {
        store.subscribe(self)
    }
}

extension MessageListViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = State
    
    func newState(state: StoreSubscriberStateType) {
        
    }
}
