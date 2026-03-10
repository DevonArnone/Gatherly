//
//  ProfileViewModel.swift
//  Gatherly
//
//  Created by Devon Arnone on 2/16/26.
//

import Foundation

@Observable
final class ProfileViewModel {
    let tabs = ["RSVP'd", "Past Events"]
    var selectedTab: String = "RSVP'd"

    func selectTab(tab: String) {
        selectedTab = tab
        filterEvents()
    }

    func filterEvents() {
        // No-op for now
    }
}
