//
//  NetworkManager.swift
//  brastlewark
//
//  Created by Alex Hernández on 27/02/2021.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseURL = Constants.baseURL
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    
    func getBrastleWarkCensus(completed: @escaping (Result<[Brastlewark], BWError>) -> Void) {
        
        guard let url = URL(string: NetworkManager.shared.baseURL) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let brastlewarkResponse = try decoder.decode(BrastlewarkResponse.self, from: data)
                completed(.success(brastlewarkResponse.brastlewark ?? []))
            } catch {
                completed(.failure(.invalidData))
            }
            
        }.resume()
    }
    
    func downloadImage(id: String, from urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: id)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let self = self,
                error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else {
                    completed(nil)
                    return
                }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        
        task.resume()
    }
}

