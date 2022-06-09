//
//  ApiCaller.swift
//  News
//
//  Created by Павел Курзо on 8.06.22.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    struct Constants {
        static let topHeadLinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=PL&apiKey=eda6154a62744b7bbad849130a7f7b6f")
    }
    
    private init() {}
    
    public func getTopStories( completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.topHeadLinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("\(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}

struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable {
    let name: String
}


