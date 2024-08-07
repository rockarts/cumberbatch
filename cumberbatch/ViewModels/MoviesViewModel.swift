//
//  MoviesViewModel.swift
//  cumberbatch
//
//  Created by Steven Rockarts on 2024-08-07.
//

import Foundation
import Combine

@MainActor
class MoviesViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var error: MovieDBError?
    
    private var service: MovieDBService
    
    init(service: MovieDBService = MovieDBService()) {
        self.service = service
    }
    
    func loadMovies() async {
        isLoading = true
        error = nil
        
        do {
            movies = try await service.fetchBenedictCumberbatchMovies()
        } catch {
            self.error = error as? MovieDBError ?? .networkError(error)
        }
        
        isLoading = false
    }
}
