//
//  EventService.swift
//  Gatherly
//
//  Created by Devon Arnone on 3/05/26.
//

import Foundation
import Observation
import UIKit

@Observable
class EventService {
    public static let shared: EventService = EventService()

    let baseURL: URL = URL(string: "https://gatherly-backend-q9vm.onrender.com/")!

    func getEvents() async throws -> [Event] {
        let path = baseURL.appending(path: "events")
        let (data, response) = try await URLSession.shared.data(from: path)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let events = try decoder.decode(EventsResponse.self, from: data)
        return events.events
    }

    func createEvent(
        title: String,
        description: String,
        timestamp: Date,
        location: String,
        uiImage: UIImage? = nil
    ) async throws -> Event? {
        let path = baseURL.appending(path: "events")
        var imageString: String = ""

        if let image = uiImage, let data = image.jpegData(compressionQuality: 0.8) {
            imageString = "data:image/jpeg;base64,\(data.base64EncodedString())"
        }

        var request = URLRequest(url: path)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = Event(
            title: title,
            location: location,
            description: description,
            timestamp: timestamp,
            image: imageString
        )

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        request.httpBody = try encoder.encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 201 else {
            return nil
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let created = try decoder.decode(Event.self, from: data)
        return created
    }

    func editEvent(
        id: String,
        title: String,
        description: String,
        timestamp: Date,
        location: String,
        uiImage: UIImage? = nil
    ) async throws {
        let path = baseURL.appending(path: "events/\(id)")

        var request = URLRequest(url: path)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Backend currently does not support image edits. Keep this parameter for API parity.
        let _ = uiImage
        let body = Event(
            title: title,
            location: location,
            description: description,
            timestamp: timestamp,
            image: nil
        )

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        request.httpBody = try encoder.encode(body)

        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }

    func deleteEvent(id: String) async throws {
        let path = baseURL.appending(path: "events/\(id)")

        var request = URLRequest(url: path)
        request.httpMethod = "DELETE"

        let body = ["creatorPid": "730751173"]
        let encoder = JSONEncoder()
        let data = try encoder.encode(body)
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}
