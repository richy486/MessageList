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
import AFDateHelper

class MessageListViewModel {
    
    // MARK: - Observable vars
    
    let isLoading = Variable<Bool>(false)
    
    private let messages = Variable<[Message]>([])
    
    // Using a lazy var here so we can keep one Variable holding the messages locally and reference the data models from a single source
    // (after recieving them from the state update)
    lazy var content: Observable<[MessageListSectionPresenter]> = {
        
        return self.messages.asObservable().map { messages -> [MessageListSectionPresenter] in
            
            let itemPresenters = messages.map { message -> MessageListItemPresenter in
                // Using a fake date for demonstration, as the posts are from two years ago
                // TODO: Put this as an option in a debug menu
                MessageListItemPresenter(heading: message.author.name,
                                         subTitle: message.updated.shiftedToThisHour().toStringWithRelativeTime(),
                                         iconImageUrl: URL(string: "\(Constants.baseUrlString)\(message.author.photoUrl)"),
                                         content: message.content,
                                         id: message.id)
            }
            return [MessageListSectionPresenter(title: "Top", items: itemPresenters, id: 0)]
        }
    }()
    fileprivate let didSelectIndexPathSubject = PublishSubject<IndexPath>()
    
    // MARK: - Properties
    fileprivate var disposeBag = DisposeBag()
    
    
    required init() {
        store.subscribe(self)
        
        store.dispatch(MessagesAction.fetch)
        
        // Deriving the message Id from the index path, this is so we aren't using the presenters for referencing the actual data models even
        // though they have Ids themselves, they should only be used for presentation.
        didSelectIndexPathSubject
            .withLatestFrom(messages.asObservable()) { (indexPath: $0, messages: $1) }
            .flatMap { arg -> Observable<Int> in
                guard arg.indexPath.row < arg.messages.count else {
                    return Observable.empty()
                }
                let messageId = arg.messages[arg.indexPath.row].id
                print("deleting at: \(arg.indexPath), id: \(messageId)")
                
                print("\(arg.messages.map{ ( $0.id, $0.author.name ) })")
                
                return Observable.just(messageId)
            }.subscribe(onNext: { messageId in
                store.dispatch(MessagesAction.remove(withId: messageId))
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Public fuctions
    
    func tableDidReachNearEnd() {
        isLoading.value = true
        
        store.dispatch(MessagesAction.fetch)
    }
    
    func deleteItem(at indexPath: IndexPath) {
        
        didSelectIndexPathSubject.onNext(indexPath)
    }
}

extension MessageListViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = State
    
    func newState(state: StoreSubscriberStateType) {
        if state.messagesState.messages.messages.count > 0 {
            
            messages.value = state.messagesState.messages.messages
            isLoading.value = false
        } else {
            print("no messages yet")
            isLoading.value = true
        }
    }
}
