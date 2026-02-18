//
//  HomeView.swift
//  Gatherly
//
//  Created by Devon Arnone on 2/16/26.
//

import SwiftUI

struct HomeView: View {
    @Bindable var vm: EventsViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]

    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading {
                    ProgressView("Loading events…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = vm.errorMessage {
                    ContentUnavailableView(
                        "Couldn't load events",
                        systemImage: "exclamationmark.triangle",
                        description: Text(error)
                    )
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Button(action: {}) {
                                    Label("Sort", systemImage: "arrow.up.arrow.down")
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 4)

                            LazyVGrid(columns: columns, spacing: 15) {
                                ForEach(vm.filteredEventIndices, id: \.self) { index in
                                    let event = vm.fetchedEvents[index]
                                    NavigationLink(value: event) {
                                        EventCardView(event: event)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                    }
                    .navigationDestination(for: Event.self) { event in
                        EventDetailsView(event: event)
                    }
                }
            }
            .navigationTitle("Events")
            .searchable(text: $vm.searchText, prompt: "Search events")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink("+ Create Event") {
                        AddEventView(vm: AddEventViewModel())
                    }
                }
            }
            .task {
                await vm.fetchEvents()
            }
        }
    }
}

#Preview {
    HomeView(vm: EventsViewModel())
}
