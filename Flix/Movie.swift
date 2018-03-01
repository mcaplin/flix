//
//  Movie.swift
//  Flix
//
//  Created by Michelle Caplin on 2/28/18.
//  Copyright © 2018 Michelle Caplin. All rights reserved.
//

import Foundation
import UIKit

class Movie {
    var id: Int
    var title: String
    var posterUrl: String?//URL?
    var backdropPath: String?
    var overview: String
    var rating: CGFloat
    var releaseDate: String
    
    init(dictionary: [String: Any]) {
        id = dictionary["id"] as? Int ?? -1
        title = dictionary["title"] as? String ?? "No title"
        posterUrl = dictionary["poster_path"] as? String//as? URL
        backdropPath = dictionary["backdrop_path"] as? String
        overview = dictionary["overview"] as? String ?? "No overview."
        rating = dictionary["vote_average"] as? CGFloat ?? 0.0
        releaseDate = dictionary["release_date"] as? String ?? "No release date"
        
        
        // Set the rest of the properties
    }
    class func movies(dictionaries: [[String: Any]]) -> [Movie] {
        var movies: [Movie] = []
        for dictionary in dictionaries {
            let movie = Movie(dictionary: dictionary)
            movies.append(movie)
        }
        
        return movies
    }
}
