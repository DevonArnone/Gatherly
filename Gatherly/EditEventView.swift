//
//  EditEventView.swift
//  Gatherly
//
//  Created by Devon Arnone on 2/11/26.
//

import SwiftUI

struct EditEventView: View {
    @Environment(\.dismiss) private var dismiss
    @State var event: Event

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Change Cover Photo")
                        .font(.headline)
                        .foregroundColor(.white)
                    HStack(spacing: 12) {
                        Button(action: {}) {
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(.cyan)
                                .frame(width: 80, height: 80)
                                .background(Color.white.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        Image("Band")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Event Title")
                        .font(.headline)
                        .foregroundColor(.white)
                    TextField("", text: $event.title)
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .overlay(alignment: .bottom) {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray)
                        }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Location")
                        .font(.headline)
                        .foregroundColor(.white)
                    TextField("", text: $event.location)
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .overlay(alignment: .bottom) {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray)
                        }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Date and Time")
                        .font(.headline)
                        .foregroundColor(.white)
                    DatePicker("", selection: $event.timestamp, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .colorScheme(.dark)
                        .tint(.cyan)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Event Description")
                        .font(.headline)
                        .foregroundColor(.white)
                    TextField("", text: $event.description, axis: .vertical)
                        .foregroundColor(.white)
                        .lineLimit(3...8)
                        .padding(.vertical, 8)
                        .overlay(alignment: .bottom) {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray)
                        }
                }

                Button(action: {}) {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.cyan, lineWidth: 2)
                        )
                }
                .padding(.top, 8)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .background(Color.black.ignoresSafeArea())
        .navigationTitle("Edit Event")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.white)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        EditEventView(event: Event(
            title: "Sunset Concert",
            location: "PNC Music Pavilion, Charlotte, NC",
            description: "Qorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus. Sed dignissim, metus nec fringilla accumsan.",
            timestamp: Date()
        ))
    }
}
