//
//  EditEventViewModel.swift
//  Gatherly
//
//  Created by Devon Arnone on 2/16/26.
//

import Foundation

@Observable
final class EditEventViewModel {
    var title: String
    var location: String
    var description: String
    var timestamp: Date

    init(event: Event) {
        self.title = event.title
        self.location = event.location
        self.description = event.description
        self.timestamp = event.timestamp
    }
}
