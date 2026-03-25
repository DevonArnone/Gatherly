//
//  ContentView.swift
//  Gatherly
//
//  Created by Devon Arnone on 2/10/26.
//

import SwiftUI

struct ContentView: View {
    @State private var eventsVM = EventsViewModel()

    var body: some View {
        TabView {
            HomeView(vm: eventsVM)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            EventMapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            ProfileView(vm: ProfileViewModel())
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
