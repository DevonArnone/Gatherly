//
//  EventsMapViewModel.swift
//  Gatherly
//
//  Created by Devon Arnone on 3/17/26.
//

import CoreLocation
import Foundation
import Observation

@Observable
final class EventsMapViewModel {
    var events: [Event] = []
    var annotations: [EventAnnotation] = []
    var loadingState: LoadingState = .idle
    var isError: Bool = false
    var errorString: String = ""

    private let geocoder = CLGeocoder()

    func load() async throws {
        loadingState = .loading
        isError = false
        errorString = ""

        do {
            let response = try await EventService.shared.getEvents()
            events = response

            let addressEvents = response.filter { !$0.location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

            annotations.removeAll()
            for event in addressEvents {
                if let coordinate = try await geocode(event.location) {
                    annotations.append(
                        EventAnnotation(
                            id: event.id ?? UUID().uuidString,
                            event: event,
                            coordinate: coordinate
                        )
                    )
                }
            }

            loadingState = .success
        } catch let error as ErrorType {
            loadingState = .failed(error)
            isError = true
            errorString = error.localizedDescription
            throw error
        } catch {
            loadingState = .failed(.geocodingError)
            isError = true
            errorString = ErrorType.geocodingError.localizedDescription
            throw ErrorType.geocodingError
        }
    }

    private func geocode(_ address: String) async throws -> CLLocationCoordinate2D? {
        try await withCheckedThrowingContinuation { continuation in
            geocoder.geocodeAddressString(address) { places, error in
                if error != nil {
                    continuation.resume(throwing: ErrorType.geocodingError)
                    return
                }

                let coordinate = places?.first?.location?.coordinate
                continuation.resume(returning: coordinate)
            }
        }
    }
}
