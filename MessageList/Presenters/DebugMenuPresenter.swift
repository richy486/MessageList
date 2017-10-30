//
//  DebugMenuPresenter.swift
//  MessageList
//
//  Created by Richard Adem on 29/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import Foundation
import RxDataSources

enum DebugOptionState {
    case none
    case enabled
    case disabled
}

// MARK: Item

struct DebugMenuItemPresenter {
    let title: String
    let iconCharacter: Character
    let optionState: DebugOptionState
}

// MARK: Section

struct DebugMenuSectionPresenter {
    
    let title: String
    var items: [Item]
}

extension DebugMenuSectionPresenter: SectionModelType {
    typealias Item = DebugMenuItemPresenter
    
    public init(original: DebugMenuSectionPresenter, items: [DebugMenuSectionPresenter.Item]) {
        self = original
        self.items = items
    }
}
