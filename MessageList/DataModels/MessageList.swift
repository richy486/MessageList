//
//  Messages.swift
//  MessageList
//
//  Created by Richard Adem on 26/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import Foundation

struct MessageList: Codable {
    var pageToken: String?
    var messages: [Message]
}

extension MessageList: Requestable {
    func fetchRequest() throws -> URLRequest {
        
        var urlString = "\(Constants.baseUrlString)/messages?limit=20"
        if let pageToken = pageToken {
            urlString.append("&pageToken=\(pageToken)")
        }
        
        guard let url = URL(string: urlString) else {
            throw RequestableError.couldNotGenerateUrl
        }
        
        return URLRequest(url: url)
    }
}
