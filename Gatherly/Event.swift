//
//  Event.swift
//  Gatherly
//
//  Created by Devon Arnone on 2/10/26.
//

import Foundation

struct Event: Hashable, Codable, Identifiable {
    var id: String?
    var creatorPID: String = "730751173"
    var title: String
    var location: String
    var description: String
    var timestamp: Date
    var image_url: String?
    var image: String?

    enum CodingKeys: String, CodingKey {
        case id, title, location, description, timestamp, image_url, image
        case creatorPID = "creatorPid"
    }
}

struct EventsResponse: Codable {
    let events: [Event]
}
