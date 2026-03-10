//
//  EventsViewModel.swift
//  Gatherly
//
//  Created by Devon Arnone on 2/16/26.
//

import Foundation

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
            fetchedEvents = try await EventService.shared.getEvents()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
