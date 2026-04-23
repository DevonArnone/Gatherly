//
//  EventsViewModel.swift
//  Gatherly
//
//  Created by Devon Arnone on 2/16/26.
//

import Foundation

@Observable
final class EventsViewModel {
    enum SortOption {
        case none, alphabetical, upcoming
    }

    var searchText: String = ""
    var fetchedEvents: [Event] = []
    var loadingState: LoadingState = .idle
    var isError: Bool = false
    var errorString: String = ""
    var sortOption: SortOption = .none

    var isLoading: Bool {
        if case .loading = loadingState {
            return true
        }
        return false
    }

    var filteredAndSortedEvents: [Event] {
        var eventsToShow = fetchedEvents.filter { event in
            searchText.isEmpty || event.title.localizedCaseInsensitiveContains(searchText)
        }
        switch sortOption {
        case .none:
            break
        case .alphabetical:
            eventsToShow.sort { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        case .upcoming:
            eventsToShow = eventsToShow.filter { $0.timestamp > Date.now }
            eventsToShow.sort { $0.timestamp < $1.timestamp }
        }
        return eventsToShow
    }

    func fetchEvents() async {
        loadingState = .loading
        isError = false
        errorString = ""

        do {
            fetchedEvents = try await EventService.shared.getEvents()
            loadingState = .success
        } catch let error as ErrorType {
            loadingState = .failed(error)
            isError = true
            errorString = error.localizedDescription
        } catch {
            loadingState = .failed(.unknown)
            isError = true
            errorString = error.localizedDescription
        }
    }
}
