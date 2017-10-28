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
//    case let action as CreateBookmark:
//        let bookmark = (route: action.route, routeSpecificData: action.routeSpecificData)
//        state.append(bookmark)
//        return state
        
        let messagesCollection = state.messages.messages + messages.messages
        state.messages = Messages(pageToken: messages.pageToken, messages: messagesCollection)
        
//        print("state: token \(state.messages.pageToken)")
        break
    }
    
    return state
}
