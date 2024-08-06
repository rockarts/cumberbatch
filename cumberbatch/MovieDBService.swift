//
//  MovieDBService.swift
//  cumberbatch
//
//  Created by Steven Rockarts on 2024-07-28.
//

import Foundation

//


class MovieDBService {
    static let apiKey = ""
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
                let result = try JSONDecoder().decode(MovieCredits.self, from: data)
                let movies = result.cast
                DispatchQueue.main.async {
                    completion(movies)
                }
            } catch {
                print("Error decoding JSON: \(error)")
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
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
}

struct MovieCredits: Codable {
    let cast: [Movie]
}
