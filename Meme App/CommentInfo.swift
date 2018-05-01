//
//  CommentInfo.swift
//  Meme App
//
//  Created by Doren Proctor on 4/30/18.
//  Copyright © 2018 Doren Proctor. All rights reserved.
//

import Foundation

struct CommentInfo: Codable {
    var imageId: Int
    var content: String
    var user: String
    var date: String
    var upvotes: Int
    var downvotes: Int
    var upvoters: [String]
    var downvoters: [String]
    var id: String
    enum Keys: String, CodingKey {
        case imageId
        case content
        case user
        case date
        case upvotes
        case downvotes
        case upvoters
        case downvoters
        case id = "_id"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: Keys.self)
        self.imageId = try valueContainer.decode(Int.self, forKey: Keys.imageId)
        self.content = try valueContainer.decode(String.self, forKey: Keys.content)
        self.user = try valueContainer.decode(String.self, forKey: Keys.user)
        self.date = try valueContainer.decode(String.self, forKey: Keys.date)
        self.upvotes = try valueContainer.decode(Int.self, forKey: Keys.upvotes)
        self.downvotes = try valueContainer.decode(Int.self, forKey: Keys.downvotes)
        self.upvoters = try valueContainer.decode([String].self, forKey: Keys.upvoters)
        self.downvoters = try valueContainer.decode([String].self, forKey: Keys.downvoters)
        self.id = try valueContainer.decode(String.self, forKey: Keys.id)
    }
}

// [{"upvotes":0,"downvotes":0,"upvoters":[],"downvoters":[],"date":"2018-04-28T01:17:06.399Z","_id":"5ae3cb920a0660080c8f5fe3","imageId":0,"content":"Generic comment.","user":"someUsername","__v":0}]
