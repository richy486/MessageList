//
//  AppReducer.swift
//  MessageList
//
//  Created by Richard Adem on 26/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import ReSwift

func appReducer(action: Action, state: State?) -> State {
    return State(
        messagesState: messagesReducer(state: state?.messagesState, action: action),
        settingsState: settingsReducer(state: state?.settingsState, action: action)
    )
}
