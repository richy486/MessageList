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
        
//        let messagesCollection = state.messages.messages + messages.messages
//        state.messages = Messages(pageToken: messages.pageToken, messages: messagesCollection)
        state.messages.messages.append(contentsOf: messages.messages)
        state.messages.pageToken = messages.pageToken
//        print("state: token \(state.messages.pageToken)")
        break
    case .remove(let withId):
//        let messageIndex: Int?
//        do {
//            messageIndex = try state.messages.messages.index(where: { message in
//                message.id == withId
//            })
//        } catch {
//            break
//        }
        
        guard let messageIndex: Int = state.messages.messages.index(where: { message in
            message.id == withId
        }) else {
            break
        }
        
//        var messagesCollection = state.messages.messages
//        messagesCollection.remove(at: messageIndex)
//
//        state.messages = Messages(pageToken: state.messages.pageToken, messages: messagesCollection)
        
        state.messages.messages.remove(at: messageIndex)
        
        print("deleted now:\n\(state.messages.messages.map{ ( $0.id, $0.author.name ) })")
        break
    }
    
    return state
}
