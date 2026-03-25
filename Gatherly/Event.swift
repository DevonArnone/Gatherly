//
//  Event.swift
//  Gatherly
//
//  Created by Devon Arnone on 2/10/26.
//

import CoreLocation
import Foundation

struct Event: Hashable, Codable, Identifiable {
    var id: String?
    var creatorPid: String = "730751173"
    var title: String
    var location: String
    var description: String
    var timestamp: Date
    var image_url: String?
    var image: String?
}

struct EventsResponse: Codable {
    let events: [Event]
}

struct EventAnnotation: Identifiable {
    let id: String
    let event: Event
    let coordinate: CLLocationCoordinate2D
}
