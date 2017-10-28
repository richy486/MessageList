//
//  Requestable.swift
//  MessageList
//
//  Created by Richard Adem on 28/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import Foundation

enum RequestableError: Error {
    case couldNotGenerateUrl
}

protocol Requestable {
    func fetchRequest() throws -> URLRequest
}
