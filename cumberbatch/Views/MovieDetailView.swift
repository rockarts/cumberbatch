//
//  MovieDetailView.swift
//  cumberbatch
//
//  Created by Steven Rockarts on 2024-07-28.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @StateObject private var viewModel = MovieDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(movie.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 300)
                .cornerRadius(10)
                
                Text("Synopsis")
                    .font(.headline)
                
                Text(movie.overview)
                    .font(.body)
                
                Text("Related Movies")
                    .font(.subheadline)
                    .fontWeight(.bold)
                
                if viewModel.isLoading {
                    ProgressView("Loading related movies...")
                } else if let error = viewModel.error {
                    ErrorView(error: error, retryAction: {
                        Task { await viewModel.loadRelatedMovies(for: movie.id) }
                    })
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(viewModel.relatedMovies) { relatedMovie in
                                MovieRow(movie: relatedMovie)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadRelatedMovies(for: movie.id)
        }
    }
}

#Preview {
    MovieDetailView(movie: Movie(id: 1100099, title: "We Live in Time", posterPath: "/nmU3WgYuv7TyCrImrVtYG2VB6U6.jpg", overview: "Almut finds her life forever changed by a chance encounter with Tobias, a recent divorcé. But after falling for each other, building a home, and starting a family, a difficult truth is revealed."))
}
