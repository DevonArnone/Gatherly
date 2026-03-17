//
//  EventCardView.swift
//  Gatherly
//
//  Created by Devon Arnone on 2/11/26.
//

import SwiftUI

struct EventCardView: View {
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading) {
            if let imageEvent = event.image_url {
                if let url = URL(string: imageEvent) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                        case .failure:
                            Rectangle()
                                .foregroundStyle(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(height: 200)
                    .clipped()
                } else {
                    Rectangle()
                        .foregroundStyle(.gray)
                        .frame(height: 200)
                }
            } else {
                Image("Band")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipped()
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(event.title)
                    .font(.headline)
                Text(event.timestamp.formatted(date: .abbreviated, time: .omitted))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(12)
        }
        .background(.regularMaterial)
        .cornerRadius(15)
    }
}

#Preview {
    EventCardView(event: Event(
        title: "Sunset Concert",
        location: "Fourth Ward, Charlotte, NC",
        description: "Experience a live concert as the sun sets over Charlotte!",
        timestamp: Date(),
        image: "Band"
    ))
    .frame(width: 170)
    .padding()
}
