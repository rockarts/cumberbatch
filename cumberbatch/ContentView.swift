//
//  ContentView.swift
//  cumberbatch
//
//  Created by Steven Rockarts on 2024-07-22.
//

import SwiftUI

struct ContentView: View {
    @State private var movies: [Movie] = []
    
    var body: some View {
        NavigationView {
            List(movies) { movie in
                NavigationLink(destination: MovieDetailView(movie: movie)) {
                    MovieRow(movie: movie)
                }
            }
            .navigationTitle("Benedict Cumberbatch Movies")
            .onAppear {
                loadMovies()
            }
        }
    }
    
    func loadMovies() {
        MovieDBService.fetchBenedictCumberbatchMovies { fetchedMovies in
            self.movies = fetchedMovies
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
