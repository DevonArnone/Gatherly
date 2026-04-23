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
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Menu {
                        Button("Alphabetical") { vm.sortOption = .alphabetical }
                        Button("Upcoming") { vm.sortOption = .upcoming }
                        Button("None") { vm.sortOption = .none }
                    } label: {
                        Text("Sort By")
                            .padding(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(.primary, lineWidth: 1)
                            )
                    }

                    Spacer()

                    NavigationLink {
                        AddEventView(vm: AddEventViewModel())
                    } label: {
                        Text("+ Create Event")
                            .padding(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(.primary, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal)

                Group {
                    switch vm.loadingState {
                    case .loading:
                        ProgressView("Loading events…")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    case .failed(let errorType):
                        ContentUnavailableView {
                            Label("Something went wrong", systemImage: "x.circle.fill")
                        } description: {
                            Text(errorType.localizedDescription)
                        }
                    case .idle, .success:
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 15) {
                                ForEach(vm.filteredAndSortedEvents, id: \.id) { event in
                                    NavigationLink(value: event) {
                                        EventCardView(event: event)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 40)
                        }
                        .refreshable {
                            await vm.fetchEvents()
                        }
                    }
                }
            }
            .navigationDestination(for: Event.self) { event in
                EventDetailsView(vm: EventDetailsViewModel(event: event))
            }
            .navigationTitle("Events")
            .searchable(text: $vm.searchText, prompt: "Search events")
            .task {
                await vm.fetchEvents()
            }
        }
        .alert("There was an error", isPresented: $vm.isError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(vm.errorString)
        }
    }
}

#Preview {
    HomeView(vm: EventsViewModel())
}
