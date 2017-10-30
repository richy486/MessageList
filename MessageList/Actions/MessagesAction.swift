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
            DispatchQueue.main.async {
                store.dispatch(MessagesAction.fetchFailed(error: error))
            }
            return nil
        }
        
        let session = URLSession.shared
        print("fetching")
        session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    store.dispatch(MessagesAction.fetchFailed(error: error))
                }
                return
            }
            
            guard let responseData = data else {
                let error = FetchError.emptyData
                DispatchQueue.main.async {
                    store.dispatch(MessagesAction.fetchFailed(error: error))
                }
                
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
        
        return MessagesAction.fetchStarted
    }
    
    case fetchStarted
    case fetched(messages: Messages)
    case fetchFailed(error: Error)
    case fetchReset
    case remove(withId: Int)
    case clearContent
}
