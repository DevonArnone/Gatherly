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
                    Image(systemName: "house")
                }
            ProfileView(vm: ProfileViewModel())
                .tabItem {
                    Image(systemName: "person.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
