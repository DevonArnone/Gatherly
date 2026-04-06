import Foundation
import SwiftData

@Model
class RSVPedEvent {
    @Attribute(.unique) var id: String
    var title: String
    var location: String
    var creatorPid: String
    var eventDescription: String
    var timestamp: Date
    var image_url: String?

    init(id: String, title: String, location: String, creatorPid: String, eventDescription: String, timestamp: Date, image_url: String?) {
        self.id = id
        self.title = title
        self.location = location
        self.creatorPid = creatorPid
        self.eventDescription = eventDescription
        self.timestamp = timestamp
        self.image_url = image_url
    }
}
