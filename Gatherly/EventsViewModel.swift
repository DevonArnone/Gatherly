//
//  EventsViewModel.swift
//  Gatherly
//
//  Created by Devon Arnone on 2/16/26.
//

import Foundation

private let eventsURL = URL(string: "https://gatherly-backend-q9vm.onrender.com/events")!

@Observable
final class EventsViewModel {
    var searchText: String = ""
    var fetchedEvents: [Event] = []
    var isLoading: Bool = false
    var errorMessage: String?

    var filteredEventIndices: [Int] {
        if searchText.isEmpty {
            return Array(fetchedEvents.indices)
        }
        return fetchedEvents.indices.filter { index in
            fetchedEvents[index].title.localizedCaseInsensitiveContains(searchText)
        }
    }

    func fetchEvents() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let (data, _) = try await URLSession.shared.data(from: eventsURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let response = try decoder.decode(EventsResponse.self, from: data)
            fetchedEvents = response.events
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
