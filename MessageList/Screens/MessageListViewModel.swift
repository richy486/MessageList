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
    
//    let content = Variable<[MessageListSectionPresenter]>([])
    let isLoading = Variable<Bool>(false)
    
    private let messages = Variable<[Message]>([])
    lazy var content: Observable<[MessageListSectionPresenter]> = {
//        let content = Variable<[MessageListSectionPresenter]>([])
        
        let a = self.messages.asObservable().map { messages -> [MessageListSectionPresenter] in
            
            let itemPresenters = messages.map{ message in

                MessageListItemPresenter(title: message.author.name,
                                         subTitle: "\(message.updated)", // TODO: format this here
                    iconImageUrl: message.author.photoUrl,
                    content: message.content)
            }
            let b = [MessageListSectionPresenter(title: "Top", items: itemPresenters)]
            return b
        }
        return a
        
//        return content
    }()
    fileprivate let didSelectIndexPathSubject = PublishSubject<IndexPath>()
    
    
    // Using a map table so we can have a weak reference to the
//    var idMap = NSMapTable<IndexPath, Int>(keyOptions: [.StrongMemory], valueOptions: [.WeakMemory])
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
        
        didSelectIndexPathSubject
            .withLatestFrom(messages.asObservable()) { (indexPath: $0, messages: $1) }
//            .withLatestFrom(viewModel.isLoading.asObservable()) { (offset: $0, isLoading: $1) }
            .flatMap { arg -> Observable<Int> in
                guard arg.indexPath.row < arg.messages.count else {
                    return Observable.empty()
                }
                return Observable.just(arg.messages[arg.indexPath.row].id)
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
        
//        let messageId = content.value[0].items[indexPath.row].id
        
//        store.dispatch(MessagesAction.remove(withId: messageId))
        
        didSelectIndexPathSubject.onNext(indexPath)
    }
}

extension MessageListViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = State
    
    func newState(state: StoreSubscriberStateType) {
        if state.messagesState.messages.messages.count > 0 {
            
//            let itemPresenters = state.messagesState.messages.messages.map { message in
//                MessageListItemPresenter(title: message.author.name,
//                                         subTitle: "\(message.updated)", // TODO: format this here
//                                         iconImageUrl: message.author.photoUrl,
//                                         content: message.content)
//            }
//            content.value = [MessageListSectionPresenter(title: "Top", items: itemPresenters)] // TODO: can we remove this title?
            messages.value = state.messagesState.messages.messages
            
            isLoading.value = false
        } else {
            print("no messages yet")
            isLoading.value = true
        }
    }
}
