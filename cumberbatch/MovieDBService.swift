//
//  MovieDBService.swift
//  cumberbatch
//
//  Created by Steven Rockarts on 2024-07-28.
//

import Foundation

class MovieDBService {
    static let apiKey = "8c5c2111da98be92e98feebbb80da17f"
    static let baseURL = "https://api.themoviedb.org/3"
    
    static func fetchBenedictCumberbatchMovies(completion: @escaping ([Movie]) -> Void) {
        let urlString = "\(baseURL)/person/71580/movie_credits?api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion([])
                return
            }
            
            do {
                debugPrint(String(decoding: data, as: UTF8.self))
                let result = try JSONDecoder().decode(MovieCredits.self, from: data)
                let movies = result.cast
                DispatchQueue.main.async {
                    completion(movies)
                }
            } catch {
                debugPrint("Error decoding JSON: \(error)")
                completion([])
            }
        }.resume()
    }
    
    static func fetchMovieDetails(movieId: Int, completion: @escaping (Movie?) -> Void) {
        let urlString = "\(baseURL)/movie/\(movieId)?api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let movie = try JSONDecoder().decode(Movie.self, from: data)
                DispatchQueue.main.async {
                    completion(movie)
                }
            } catch {
                debugPrint("Error decoding JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    static func fetchRelatedMovies(movieId: Int, completion: @escaping ([Movie]) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)/similar?api_key=\(apiKey)") else {
            completion([])
            return
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "page", value: "1")
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion([])
                return
            }
            
            do {
                print(String(decoding: data, as: UTF8.self))
                let response = try JSONDecoder().decode(MovieResponse.self, from: data)
                let movies = response.results
                
                DispatchQueue.main.async {
                    completion(movies)
                }
            } catch {
                debugPrint("Error decoding JSON: \(error)")
                completion([])
            }
        }.resume()
    }
}
