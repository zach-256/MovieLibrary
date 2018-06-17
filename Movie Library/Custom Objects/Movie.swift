//
//  Movie.swift
//  Movie Library
//
//  Created by Zachary Whitten on 6/13/18.
//  Copyright © 2018 16^2. All rights reserved.
//

import Cocoa

class Movie: NSObject, NSCoding {
    
    var title: String?
    var genre: String?
    var director: String?
    var year: Int?
    var comments: String?
    var movieArt: NSImage?
    var lastPlayed: NSDate?
    var playCount: Int
    var filepath: URL?
    
    init(aTitle: String, aFilepath: URL) {
        title = aTitle
        filepath = aFilepath
        playCount = 0
    }
    
    //Encoding fucntion for saving. Encode each object with a key for retervial
    func encode(with coder: NSCoder) {
        coder.encode(title, forKey: "title")
        coder.encode(genre, forKey: "genre")
        coder.encode(director, forKey: "director")
        coder.encode(year, forKey: "year")
        coder.encode(comments, forKey: "comments")
        coder.encode(movieArt, forKey: "movieArt")
        coder.encode(lastPlayed, forKey: "lastPlayed")
        coder.encode(playCount, forKey: "playCount")
        coder.encode(filepath, forKey: "filepath")
    }
    
    //Decode each individual object and then create a new object instance
    required init?(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObject(forKey: "title") as? String
        self.genre = aDecoder.decodeObject(forKey: "genre") as? String
        self.director = aDecoder.decodeObject(forKey: "director") as? String
        self.year = aDecoder.decodeObject(forKey: "year") as? Int
        self.comments = aDecoder.decodeObject(forKey: "comments") as? String
        self.movieArt = aDecoder.decodeObject(forKey: "movieArt") as? NSImage
        self.lastPlayed = aDecoder.decodeObject(forKey: "lastPlayed") as? NSDate
        self.playCount = aDecoder.decodeObject(forKey: "playCount") as? Int ?? 0
        self.filepath = aDecoder.decodeObject(forKey: "filepath") as? URL
    }
    
    
    
    
}
