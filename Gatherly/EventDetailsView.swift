//
//  EventDetailsView.swift
//  Gatherly
//
//  Created by Devon Arnone on 2/10/26.
//

import SwiftUI
import SwiftData

struct EventDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var showDialog = false
    @State private var showEditEvent = false
    @State private var isDeleting = false
    @Bindable var vm: EventDetailsViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 16) {
                    if let imageEvent = vm.event.image_url, let url = URL(string: imageEvent) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            case .failure:
                                Rectangle()
                                    .foregroundStyle(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 280)
                        .clipped()
                    } else {
                        Image("Band")
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 280)
                            .clipped()
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text(vm.event.title)
                            .font(.title)
                            .fontWeight(.bold)

                        HStack(spacing: 12) {
                            Text(vm.event.timestamp.formatted(date: .abbreviated, time: .omitted))
                            Image(systemName: "circle.fill")
                                .font(.system(size: 5))
                            Text(vm.event.timestamp.formatted(date: .omitted, time: .shortened))
                        }
                        .font(.body)
                        .foregroundStyle(.secondary)

                        Text(vm.event.location)
                            .font(.body)
                            .foregroundStyle(.secondary)

                        Divider()
                            .padding(.vertical, 8)

                        Text("Description")
                            .font(.headline)

                        Text(vm.event.description)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)
                }

                if vm.showRSVPButton {
                    Button {
                        let rsvp = RSVPedEvent(
                            id: vm.event.id ?? UUID().uuidString,
                            title: vm.event.title,
                            location: vm.event.location,
                            creatorPid: vm.event.creatorPid,
                            eventDescription: vm.event.description,
                            timestamp: vm.event.timestamp,
                            image_url: vm.event.image_url
                        )
                        modelContext.insert(rsvp)
                        try? modelContext.save()
                        dismiss()
                    } label: {
                        Text("RSVP")
                            .font(.headline)
                            .frame(width: 150, height: 44)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.primary, lineWidth: 1)
                            )
                    }
                    .padding(.vertical, 40)
                }
            }
        }
        .refreshable {
            await vm.refreshEvent()
        }
        .navigationTitle(vm.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                }
            }
            if vm.showEllipsisButton {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showDialog = true }) {
                        Image(systemName: "ellipsis")
                    }
                }
            }
        }
        .confirmationDialog(
            "Advanced Actions",
            isPresented: $showDialog,
            titleVisibility: .visible
        ) {
            Button("Edit Event") {
                showDialog = false
                showEditEvent = true
            }
            Button("Delete Event", role: .destructive) {
                Task {
                    guard let id = vm.event.id else { return }
                    isDeleting = true
                    defer { isDeleting = false }
                    do {
                        try await EventService.shared.deleteEvent(id: id)
                        dismiss()
                    } catch {
                        print("Failed to delete event: \(error.localizedDescription)")
                    }
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Make changes to your event")
        }
        .navigationDestination(isPresented: $showEditEvent) {
            EditEventView(vm: EditEventViewModel(event: vm.event))
        }
        .disabled(isDeleting)
    }
}

#Preview {
    NavigationStack {
        EventDetailsView(vm: EventDetailsViewModel(event: Event(
            title: "Sunset Concert",
            location: "Fourth Ward, Charlotte, NC",
            description: "Experience a live concert as the sun sets over Charlotte!",
            timestamp: Date(),
            image: "Band"
        )))
    }
}
