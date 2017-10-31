//
//  Message.swift
//  MessageList
//
//  Created by Richard Adem on 26/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import Foundation

struct Message: Codable {
    let id: Int
    let content: String
    let updated: Date
    let author: Author
}

extension Message: Hashable {
    var hashValue: Int {
        return id.hashValue ^ content.hashValue ^ updated.hashValue
    }
}

func ==(lhs: Message, rhs: Message) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
