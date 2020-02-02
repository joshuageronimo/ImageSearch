//
//  NetworkService.swift
//  ImageSearch
//
//  Created by Joshua Geronimo on 2/1/20.
//  Copyright © 2020 Joshua Geronimo. All rights reserved.
//

import Foundation

class NetworkService: NSObject {
    
    static let shared = NetworkService()
    fileprivate let apiRoot = "https://images-api.nasa.gov"
    
    // MARK: GENERIC GET REQUEST METHOD
    func fetchData<T: Decodable>(apiEndPoint: String, parameters: [String: String]? = nil, completion: @escaping (T?, Error?) -> ()) {
        var components = URLComponents(string: "\(apiRoot)\(apiEndPoint)")!
        if let parameters = parameters {
            // Setup parameters
            components.queryItems = parameters.map { (key, value) in
                URLQueryItem(name: key, value: value)
            }
            
        }
        // Clean up the url
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        // Create a URLRequest Object from URLComponents
        let request = URLRequest(url: components.url!)
        
        print(request)
        
        // Create a data task
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Check if there are errors
            if let error = error {
                print("Server Error: \(error)")
                completion(nil, error)
            }

            guard let data = data else { return }
            // Decode JSON and parse it nicely into one of the model objects
            do {
                // NOTE:  uncomment code for debugging
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
//                    print("JSON GET:\n\(json)")
//                } catch let error {
//                    print("SERVER ERROR: \(error)")
//                }
                
                let object = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(object, nil)
                }
            } catch let jsonError {
                print("Failed to serialize json: \(jsonError)")
                completion(nil, jsonError)
            }
        }.resume() // call the server!
    }
}
