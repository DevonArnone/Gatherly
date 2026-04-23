//
//  EventDetailsViewModel.swift
//  Gatherly
//
//  Created by Devon Arnone on 2/10/26.
//

import Foundation
import Observation

@Observable
final class EventDetailsViewModel {
    var event: Event

    private let currentUserPid = "730751173"

    var isMine: Bool { event.creatorPid == currentUserPid }
    var navigationTitle: String { isMine ? "Your Event Details" : "Event Details" }
    var showRSVPButton: Bool { !isMine }
    var showEllipsisButton: Bool { isMine }

    init(event: Event) {
        self.event = event
    }

    func refreshEvent() async {
        guard let id = event.id else { return }
        if let updated = try? await EventService.shared.getEvent(id: id) {
            event = updated
        }
    }
}
