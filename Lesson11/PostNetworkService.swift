//
//  PostNetworkService.swift
//  Lesson11
//
//  Created by ilyas.ikhsanov on 16.11.2021.
//

import Foundation

final class PostNetworkService {
    
    let configuration = URLSessionConfiguration.default
    let decoder = JSONDecoder()
    
    func getPosts(completion: @escaping ((Result<[Post], Error>) -> Void)) {
        let session = URLSession(configuration: configuration)
        let postsURL = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        
        var request = URLRequest(url: postsURL)
        request.cachePolicy = .reloadRevalidatingCacheData
        request.httpMethod = "GET"
        
        // Если бы мы не запускали код в параллельной очереди асинхронно, о данный вызов был бы на main очереди
        print("PostNetwork service after reguest configure, ", Thread.isMainThread)
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            // Данный код в любом случае не будет выполняться на main очереди,
            // поэтому можно не беспокоится, о его выполнении в main очереди,
            // но возврат completion будет на той очереди на котором он выполнился
            print("PostNetwork service data task resume, ", Thread.isMainThread)
            var result: Result<[Post], Error> = .success([])
            if let error = error {
                result = .failure(error)
            } else if let data = data {
                do {
                    let posts = try self.decoder.decode([Post].self, from: data)
                    result = .success(posts)
                } catch {
                    result = .failure(error)
                }
            }
            
            completion(result)
        }
        dataTask.resume()
    }
}
