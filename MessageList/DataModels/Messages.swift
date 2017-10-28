//
//  Messages.swift
//  MessageList
//
//  Created by Richard Adem on 26/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import Foundation

struct Messages: Codable {
    var pageToken: String?
    var messages: [Message]
}

extension Messages: Requestable {
    func fetchRequest() throws -> URLRequest {
        
        var urlString = "https://message-list.appspot.com/messages"
        if let pageToken = pageToken {
            urlString.append("?pageToken=\(pageToken)")
        }
        
        guard let url = URL(string: urlString) else {
            throw RequestableError.couldNotGenerateUrl
        }
        
        return URLRequest(url: url)
    }
}
