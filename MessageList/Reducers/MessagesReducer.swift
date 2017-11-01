//
//  MessagesReducer.swift
//  MessageList
//
//  Created by Richard Adem on 26/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import Foundation
import ReSwift

func messagesReducer(state: MessagesState?, action: Action) -> MessagesState {
    var state = state ?? MessagesState(messagesList: MessageList(pageToken: nil, messages: []), networkState: .idle)
    
    guard let action = action as? MessagesAction else {
        return state
    }
    
    switch action {
    case .fetchStarted:
        state.networkState = .started
        break
    case .fetched(let messages):
        state.messagesList.messages.append(contentsOf: messages.messages)
        state.messagesList.pageToken = messages.pageToken
        state.networkState = .completed
        break
    case .fetchFailed(let error):
        state.networkState = .error(error: error)
        break
    case .fetchReset:
        state.networkState = .idle
    case .remove(let withId):
        guard let messageIndex: Int = state.messagesList.messages.index(where: { message in
            message.id == withId
        }) else {
            break
        }
        state.messagesList.messages.remove(at: messageIndex)
        break
    case .clearContent:
        state = MessagesState(messagesList: MessageList(pageToken: nil, messages: []), networkState: .idle)
        break
    }
    
    return state
}
