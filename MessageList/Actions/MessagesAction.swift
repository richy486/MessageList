//
//  MessagesAction.swift
//  MessageList
//
//  Created by Richard Adem on 26/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import Foundation
import ReSwift

enum MessagesAction: Action {
    
    enum FetchError: Error {
        case emptyData
    }
    
    static func fetch(state: State, store: Store<State>) -> Action? {
        
        let urlRequest: URLRequest
        do {
            urlRequest = try state.messagesState.messages.fetchRequest()
        } catch {
            print("error \(error)") // TODO: handle error
            return nil
        }
        
        let session = URLSession.shared
        print("fetching: \(urlRequest.url!)")
        session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                //completionHandler(nil, error!)
                print("error \(error!)") // TODO: handle error
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                let error = FetchError.emptyData
                //completionHandler(nil, error)
                print("error \(error)") // TODO: handle error
                return
            }
            
            //let responseString = String(data: responseData, encoding: .utf8)
            //print("response \(responseString!)")
            
            let decoder = JSONDecoder()
            //        decoder.dateEncodingStrategy = .iso8601
            //        decoder.dataDecodingStrategy = .iso8601
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            
            decoder.dateDecodingStrategy = .formatted(formatter)
            
            //        2015-02-01T08:45:23Z
            //        yyyy-MM-dd'T'HH:mm:ssZ
            do {
                let messages = try decoder.decode(Messages.self, from: responseData)
                //            completionHandler(todos, nil)
//                print("messages: \(messages)")
                
                DispatchQueue.main.async {
                    store.dispatch(MessagesAction.fetched(messages: messages))
                }
                
            } catch {
                print("error trying to convert data to JSON")
                print(error)
                //            completionHandler(nil, error)
            }
        }
        .resume()
        
        return nil // TODO: should we return an action?? maybe fetch started?
    }
    
    case fetched(messages: Messages)
}
