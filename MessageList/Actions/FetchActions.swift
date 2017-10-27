//
//  FetchActions.swift
//  MessageList
//
//  Created by Richard Adem on 26/10/17.
//  Copyright © 2017 Richard Adem. All rights reserved.
//

import ReSwift

enum FetchError: Error {
    case emptyData
}

func fetchMesages(state: State, store: Store<State>) -> Action? {
//    guard case let .loggedIn(configuration) = state.authenticationState.loggedInState  else { return nil }
//
//    Octokit(configuration).repositories { response in
//        DispatchQueue.main.async {
//            store.dispatch(SetRepositories(repositories: response))
//        }
//    }
    
    let urlRequest = URLRequest(url: URL(string: "https://message-list.appspot.com/messages")!)
    let session = URLSession.shared
    session.dataTask(with: urlRequest) { (data, response, error) in
        guard error == nil else {
            //completionHandler(nil, error!)
            print("error \(error!)")
            return
        }
        
        guard let responseData = data else {
            print("Error: did not receive data")
            let error = FetchError.emptyData
            //completionHandler(nil, error)
            print("error \(error)")
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
            print("messages: \(messages)")
        } catch {
            print("error trying to convert data to JSON")
            print(error)
//            completionHandler(nil, error)
        }
    }.resume()
    
    return nil
}
