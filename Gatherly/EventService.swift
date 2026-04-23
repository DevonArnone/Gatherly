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
    static let shared = try! EventService()

    private let baseURL: URL

    private init() throws {
        guard let url = URL(string: "https://gatherly-backend-q9vm.onrender.com/") else {
            throw ErrorType.invalidURL
        }
        baseURL = url
    }

    func getEvent(id: String) async throws -> Event {
        let path = baseURL.appending(path: "events/\(id)")
        let (data, response) = try await URLSession.shared.data(from: path)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw ErrorType.networkError
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            return try decoder.decode(Event.self, from: data)
        } catch {
            throw ErrorType.codingError
        }
    }

    func getEvents() async throws -> [Event] {
        let path = baseURL.appending(path: "events")
        do {
            let (data, response) = try await URLSession.shared.data(from: path)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw ErrorType.networkError
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                throw ErrorType.networkError
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            do {
                let events = try decoder.decode(EventsResponse.self, from: data)
                return events.events
            } catch {
                throw ErrorType.codingError
            }
        } catch let error as ErrorType {
            throw error
        } catch is URLError {
            throw ErrorType.networkError
        } catch {
            throw ErrorType.unknown
        }
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
        do {
            request.httpBody = try encoder.encode(body)
        } catch {
            throw ErrorType.codingError
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw ErrorType.networkError
            }

            guard httpResponse.statusCode == 201 else {
                throw ErrorType.networkError
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            do {
                let created = try decoder.decode(Event.self, from: data)
                return created
            } catch {
                throw ErrorType.codingError
            }
        } catch let error as ErrorType {
            throw error
        } catch is URLError {
            throw ErrorType.networkError
        } catch {
            throw ErrorType.unknown
        }
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
        do {
            request.httpBody = try encoder.encode(body)
        } catch {
            throw ErrorType.codingError
        }

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ErrorType.networkError
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                throw ErrorType.networkError
            }
        } catch let error as ErrorType {
            throw error
        } catch is URLError {
            throw ErrorType.networkError
        } catch {
            throw ErrorType.unknown
        }
    }

    func deleteEvent(id: String) async throws {
        let path = baseURL.appending(path: "events/\(id)")

        var request = URLRequest(url: path)
        request.httpMethod = "DELETE"

        let body = ["creatorPid": "730751173"]
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(body)
            request.httpBody = data
        } catch {
            throw ErrorType.codingError
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ErrorType.networkError
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                throw ErrorType.networkError
            }
        } catch let error as ErrorType {
            throw error
        } catch is URLError {
            throw ErrorType.networkError
        } catch {
            throw ErrorType.unknown
        }
    }
}
