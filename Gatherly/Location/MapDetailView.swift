//
//  MapDetailView.swift
//  Gatherly
//
//  Created by Devon Arnone on 3/17/26.
//

import SwiftUI

struct MapDetailView: View {
    let event: Event

    var body: some View {
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
                        Image("Band")
                            .resizable()
                            .scaledToFill()
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
    }
}

#Preview {
    MapDetailView(event: Event(
        title: "Sunset Concert",
        location: "Fourth Ward, Charlotte, NC",
        description: "Experience a live concert as the sun sets over Charlotte!",
        timestamp: Date(),
        image: "Band"
    ))
}
