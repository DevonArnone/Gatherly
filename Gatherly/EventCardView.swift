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
            Image(event.image ?? "Placeholder")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .clipped()
            VStack(alignment: .leading, spacing: 2) {
                            Text(event.title)
                                .font(.headline)
                                .foregroundColor(.black)
                            Text(event.timestamp.formatted(date: .abbreviated, time: .omitted))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .background(.regularMaterial)
                    .cornerRadius(15)
            }
}





#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
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
}

