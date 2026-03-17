//
//  EventDetailsView.swift
//  Gatherly
//
//  Created by Devon Arnone on 2/10/26.
//

import SwiftUI

struct EventDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showDialog = false
    @State private var showEditEvent = false
    @State private var isDeleting = false
    let event: Event

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
                if let imageEvent = event.image_url, let url = URL(string: imageEvent) {
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
                    Text(event.title)
                        .font(.title)
                        .fontWeight(.bold)

                    HStack(spacing: 12) {
                        Text(event.timestamp.formatted(date: .abbreviated, time: .omitted))
                        Image(systemName: "circle.fill")
                            .font(.system(size: 5))
                        Text(event.timestamp.formatted(date: .omitted, time: .shortened))
                    }
                    .font(.body)
                    .foregroundStyle(.secondary)

                    Text(event.location)
                        .font(.body)
                        .foregroundStyle(.secondary)

                    Divider()
                        .padding(.vertical, 8)

                    Text("Description")
                        .font(.headline)

                    Text(event.description)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)

                Spacer()
            }

            Button(action: {}) {
                Text("RSVP")
                    .font(.headline)
                    .frame(width: 150, height: 44)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.primary, lineWidth: 1)
                    )
            }
            .padding(.bottom, 40)
        }
        .navigationTitle("Event Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showDialog = true }) {
                    Image(systemName: "ellipsis")
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
                    guard let id = event.id else { return }
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
            EditEventView(vm: EditEventViewModel(event: event))
        }
        .disabled(isDeleting)
    }
}

#Preview {
    NavigationStack {
        EventDetailsView(event: Event(
            title: "Sunset Concert",
            location: "Fourth Ward, Charlotte, NC",
            description: "Experience a live concert as the sun sets over Charlotte!",
            timestamp: Date(),
            image: "Band"
        ))
    }
}
