//
//  SettingsReducer.swift
//  MessageList
//
//  Created by Richard Adem on 29/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import Foundation
import ReSwift
import SDWebImage

func settingsReducer(state: SettingsState?, action: Action) -> SettingsState {
    var state = state ?? SettingsState(useShiftedDate: true)
    
    guard let action = action as? SettingsAction else {
        return state
    }
    
    switch action {
    case .changeUseShiftedDate:
        state.useShiftedDate = !state.useShiftedDate
        break
    case .clearImageCache:
        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk()
        break
    }
    
    return state
}
