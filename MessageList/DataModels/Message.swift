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
