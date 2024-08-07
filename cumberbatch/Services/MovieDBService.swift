//
//  MovieDBService.swift
//  cumberbatch
//
//  Created by Steven Rockarts on 2024-07-28.
//

import Foundation
import Combine

import Foundation

class MovieDBService {
    let apiKey = ""
    let baseURL = "https://api.themoviedb.org/3"
    
    func fetchMovies<T: Decodable>(endpoint: Endpoint) async throws -> T {
        let urlString = "\(baseURL)\(endpoint.path)?api_key=\(apiKey)&language=en-US&page=1"
        
        guard let url = URL(string: urlString) else {
            throw MovieDBError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw MovieDBError.apiError("Invalid response")
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }

    func fetchBenedictCumberbatchMovies() async throws -> [Movie] {
        let benedictCumberBatchId = 71580
        let movieCredits: MovieCredits = try await fetchMovies(endpoint: .personMovieCredits(personId: benedictCumberBatchId))
        return movieCredits.cast
    }

    func fetchRelatedMovies(movieId: Int) async throws -> [Movie] {
        let movieResponse: MovieResponse = try await fetchMovies(endpoint: .relatedMovies(movieId: movieId))
        return movieResponse.results
    }
}

enum Endpoint {
    case personMovieCredits(personId: Int)
    case relatedMovies(movieId: Int)
    
    var path: String {
        switch self {
        case .personMovieCredits(let personId):
            return "/person/\(personId)/movie_credits"
        case .relatedMovies(let movieId):
            return "/movie/\(movieId)/similar"
        }
    }
}
