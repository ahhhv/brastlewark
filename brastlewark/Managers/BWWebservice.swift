//
//  AHVWebservice.swift
//  brastlewark
//
//  Created by Alex Hernández on 27/02/2021.
//  Copyright © 2021 Alex Hernández. All rights reserved.
//

import Foundation

class BWWebservice {
    private var urlString: String
    private var urlSession: URLSession
    
    init(urlString: String, urlSession: URLSession = .shared) {
        self.urlString = urlString
        self.urlSession = urlSession
    }
    
    func getList(completion: @escaping ([Brastlewark]?, BWError?) -> ()) {

        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let dataTask = urlSession.dataTask(with: request) { data, response, error in
            
            if let data = data,
               let responseModel = try? JSONDecoder().decode(BrastlewarkResponse.self, from: data) {
                completion(responseModel.brastlewark ?? [], nil)
            } else {
                completion(nil, BWError.invalidData)
            }
        }
        
        dataTask.resume()
    }
}
