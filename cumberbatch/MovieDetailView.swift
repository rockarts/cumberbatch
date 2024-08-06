//
//  MovieDetailView.swift
//  cumberbatch
//
//  Created by Steven Rockarts on 2024-07-28.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    
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
                    Color.gray
                }
                .frame(height: 300)
                .cornerRadius(10)
                
                Text("Synopsis")
                    .font(.headline)
                
                Text(movie.overview)
                    .font(.body)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    MovieDetailView()
//}
