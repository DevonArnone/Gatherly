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
    var loadingState: LoadingState = .idle
    var isError: Bool = false
    var errorString: String = ""

    var isLoading: Bool {
        if case .loading = loadingState {
            return true
        }
        return false
    }

    var filteredEventIndices: [Int] {
        if searchText.isEmpty {
            return Array(fetchedEvents.indices)
        }
        return fetchedEvents.indices.filter { index in
            fetchedEvents[index].title.localizedCaseInsensitiveContains(searchText)
        }
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
