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
    var state = state ?? MessagesState(messages: Messages(pageToken: nil, messages: []))
    
    guard let action = action as? MessagesAction else {
        return state
    }
    
    switch action {
    case .fetched(let messages):
        state.messages.messages.append(contentsOf: messages.messages)
        state.messages.pageToken = messages.pageToken
        break
    case .remove(let withId):
        guard let messageIndex: Int = state.messages.messages.index(where: { message in
            message.id == withId
        }) else {
            break
        }
        state.messages.messages.remove(at: messageIndex)
        break
    }
    
    return state
}
