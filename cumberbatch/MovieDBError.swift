//
//  MovieDBError.swift
//  cumberbatch
//
//  Created by Steven Rockarts on 2024-07-28.
//

import Foundation

enum MovieDBError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case noData
    case apiError(String)

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .noData:
            return "No data received"
        case .apiError(let message):
            return "API error: \(message)"
        }
    }
}
