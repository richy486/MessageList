//
//  Messages.swift
//  MessageList
//
//  Created by Richard Adem on 26/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import Foundation

struct Messages: Codable {
    let pageToken: String
    let messages: [Message]
}
