//
//  ContentView.swift
//  cumberbatch
//
//  Created by Steven Rockarts on 2024-07-22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MoviesViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading movies...")
                } else if let error = viewModel.error {
                    ErrorView(error: error, retryAction: {
                        Task { await viewModel.loadMovies() }
                    })
                } else {
                    List(viewModel.movies) { movie in
                        NavigationLink(destination: MovieDetailView(movie: movie)) {
                            MovieRow(movie: movie)
                        }
                    }
                }
            }
            .navigationTitle("Benedict Cumberbatch Movies")
        }
        .task {
            await viewModel.loadMovies()
        }
    }
}

struct MovieRow: View {
    let movie: Movie
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w92\(movie.posterPath ?? "")")) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 60, height: 90)
            .cornerRadius(5)
            
            Text(movie.title)
                .font(.headline)
        }
    }
}

#Preview {
    ContentView()
}
