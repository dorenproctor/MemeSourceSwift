//
//  ImageInfo.swift
//  Meme App
//
//  Created by Doren Proctor on 4/30/18.
//  Copyright © 2018 Doren Proctor. All rights reserved.
//

import Foundation

struct ImageInfo: Codable {
    var imageId: Int
    var description: String
    var tags: [String]
    var upvotes: Int
    var downvotes: Int
    var upvoters: [String]
    var downvoters: [String]
    enum Keys: String, CodingKey {
        case imageId
        case description
        case tags
        case upvotes
        case downvotes
        case upvoters
        case downvoters
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: Keys.self)
        self.imageId = try valueContainer.decode(Int.self, forKey: Keys.imageId)
        self.description = try valueContainer.decode(String.self, forKey: Keys.description)
        self.tags = try valueContainer.decode([String].self, forKey: Keys.tags)
        self.upvotes = try valueContainer.decode(Int.self, forKey: Keys.upvotes)
        self.downvotes = try valueContainer.decode(Int.self, forKey: Keys.downvotes)
        self.upvoters = try valueContainer.decode([String].self, forKey: Keys.upvoters)
        self.downvoters = try valueContainer.decode([String].self, forKey: Keys.downvoters)
    }
}
