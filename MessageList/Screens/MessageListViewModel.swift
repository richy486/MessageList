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
    
    private let isLoading = Variable<Bool>(false)
    private let shiftingDates = Variable<Bool>(false)
    private let triggerFetch = PublishSubject<Void>()
    private let messages = Variable<[Message]>([])
    private let didSelectIndexPathSubject = PublishSubject<IndexPath>()
    
    // Using a lazy var here so we can keep one Variable holding the messages locally and reference the data models from a single source
    // (after recieving them from the state update)
    typealias MessagesAndShifting = ([Message], Bool)
    lazy var content: Observable<[MessageListSectionPresenter]> = {
        
        return Observable.combineLatest(self.messages.asObservable(), shiftingDates.asObservable()) { (messages: $0, shiftingDates: $1) }
            .map { arg -> [MessageListSectionPresenter] in
            
            let itemPresenters = arg.messages.map { message -> MessageListItemPresenter in
                // Using a fake date for demonstration, as the posts are from two years ago
                let updatedDate: Date = arg.shiftingDates
                    ? message.updated.shiftedToThisHour()
                    : message.updated
                
                return MessageListItemPresenter(heading: message.author.name,
                                         subTitle: updatedDate.toStringWithRelativeTime(),
                                         iconImageUrl: URL(string: "\(Constants.baseUrlString)\(message.author.photoUrl)"),
                                         content: message.content,
                                         id: message.id)
            }
            return [MessageListSectionPresenter(title: "Top", items: itemPresenters, id: 0)]
        }
    }()
    let errorMessage = PublishSubject<String>()
    
    // MARK: - Properties
    private var disposeBag = DisposeBag()
    
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

                return Observable.just(messageId)
            }.subscribe(onNext: { messageId in
                store.dispatch(MessagesAction.remove(withId: messageId))
            })
            .disposed(by: disposeBag)
        
        triggerFetch.withLatestFrom(isLoading.asObservable())
            .subscribe(onNext: { [weak self] isLoading in
                if (!isLoading) {
                    self?.isLoading.value = true
                    store.dispatch(MessagesAction.fetch)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Public fuctions
    
    func tableDidReachNearEnd() {
        triggerFetch.onNext(())
    }
    
    func deleteItem(at indexPath: IndexPath) {
        didSelectIndexPathSubject.onNext(indexPath)
    }
}

extension MessageListViewModel: StoreSubscriber {
    typealias StoreSubscriberStateType = State
    
    func newState(state: StoreSubscriberStateType) {
//        if state.messagesState.messages.messages.count > 0 {
            messages.value = state.messagesState.messages.messages
//        }
        
        if case .error(let error) = state.messagesState.networkState {
            DispatchQueue.main.async {
                store.dispatch(MessagesAction.fetchReset)
            }
            errorMessage.onNext("\(error)")
        }
        
        switch state.messagesState.networkState {
        case .error(let error):
            isLoading.value = true
            DispatchQueue.main.async {
                store.dispatch(MessagesAction.fetchReset)
            }
            errorMessage.onNext("\(error)")
            break
        case .idle, .completed:
            isLoading.value = false
            break
        default:
            isLoading.value = true
            break
        }
        
        shiftingDates.value = state.settingsState.useShiftedDate
    }
}
