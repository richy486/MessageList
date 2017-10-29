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
                print("error \(error!)") // TODO: handle error
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                let error = FetchError.emptyData
                print("error \(error)") // TODO: handle error
                return
            }
            
            let decoder = JSONDecoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            decoder.dateDecodingStrategy = .formatted(formatter)
            
            do {
                let messages = try decoder.decode(Messages.self, from: responseData)
                DispatchQueue.main.async {
                    store.dispatch(MessagesAction.fetched(messages: messages))
                }
                
            } catch {
                print("error trying to convert data to JSON")
                print(error)
            }
        }
        .resume()
        
        return nil // TODO: should we return an action?? maybe fetch started?
    }
    
    case fetched(messages: Messages)
    case remove(withId: Int)
}
