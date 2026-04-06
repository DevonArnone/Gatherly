//
//  GatherlyApp.swift
//  Gatherly
//
//  Created by Devon Arnone on 2/10/26.
//

import SwiftUI
import SwiftData

@main
struct GatherlyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [RSVPedEvent.self, UserProfile.self])
    }
}
