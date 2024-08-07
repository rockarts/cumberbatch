//
//  MovieDetailViewModel.swift
//  cumberbatch
//
//  Created by Steven Rockarts on 2024-08-07.
//

import Foundation

@MainActor
class MovieDetailViewModel: ObservableObject {
    @Published var relatedMovies: [Movie] = []
    @Published var isLoading = false
    @Published var error: MovieDBError?
    
    private var service: MovieDBService
    
    init(service: MovieDBService = MovieDBService()) {
        self.service = service
    }
    
    func loadRelatedMovies(for movieId: Int) async {
        isLoading = true
        error = nil
        
        do {
            relatedMovies = try await service.fetchRelatedMovies(movieId: movieId)
        } catch {
            self.error = error as? MovieDBError ?? .networkError(error)
        }
        
        isLoading = false
    }
}
