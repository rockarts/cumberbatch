//
//  Movie.swift
//  cumberbatch
//
//  Created by Steven Rockarts on 2024-07-28.
//



import Foundation

struct Movie: Identifiable, Codable {
    let id: Int
    let title: String
    let posterPath: String?
    let overview: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
    }
}
