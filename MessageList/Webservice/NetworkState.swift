//
//  NetworkState.swift
//  MessageList
//
//  Created by Richard Adem on 29/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import Foundation

enum NetworkState {
    case idle
    case started
    case completed
    case error(error: Error)
}
