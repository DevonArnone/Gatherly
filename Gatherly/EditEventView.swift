//
//  EditEventView.swift
//  Gatherly
//
//  Created by Devon Arnone on 2/11/26.
//

import SwiftUI
import PhotosUI

struct EditEventView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var vm: EditEventViewModel

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Change Cover Photo")
                        .font(.headline)

                    HStack(spacing: 12) {
                        PhotosPicker(selection: $vm.selectedPhoto, matching: .images) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .padding(20)
                                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                        }
                        .task(id: vm.selectedPhoto) {
                            await vm.loadImage()
                        }

                        if let image = vm.image {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 75)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else if let existingImageURL = vm.existingImageURL,
                                  let url = URL(string: existingImageURL) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                case .failure:
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.gray.opacity(0.2))
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(width: 120, height: 75)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else {
                            Image("Band")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 75)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Event Title")
                        .font(.headline)
                    TextField("Write your event's title", text: $vm.title)
                        .padding(.vertical, 8)
                    Divider()
                        .overlay(.gray)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Location")
                        .font(.headline)
                    TextField("Choose location of event", text: $vm.location)
                        .padding(.vertical, 8)
                    Divider()
                        .overlay(.gray)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Date and Time")
                        .font(.headline)
                    DatePicker("", selection: $vm.timestamp, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.compact)
                        .labelsHidden()
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Event Description")
                        .font(.headline)
                    TextField("Write a description for your event", text: $vm.description, axis: .vertical)
                        .lineLimit(3...8)
                        .padding(.vertical, 8)
                    Divider()
                        .overlay(.gray)
                }

                Button(action: {
                    Task {
                        await vm.editEvent()
                    }
                }) {
                    Text("Save")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.primary, lineWidth: 1)
                        )
                }
                .padding(.top, 8)
                .disabled(vm.isSubmitting)

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)

            if vm.isSubmitting {
                Color.black.opacity(0.15)
                    .ignoresSafeArea()
                ProgressView("Saving event...")
            }
        }
        .navigationTitle("Edit Event")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert("There was an error", isPresented: $vm.isError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(vm.errorString)
        }
        .onChange(of: vm.didSaveEvent) { _, didSaveEvent in
            if didSaveEvent {
                dismiss()
            }
        }
    }
}

#Preview {
    NavigationStack {
        EditEventView(vm: EditEventViewModel(event: Event(
            title: "Sunset Concert",
            location: "PNC Music Pavilion, Charlotte, NC",
            description: "Qorem ipsum dolor sit amet, consectetur adipiscing elit.",
            timestamp: Date()
        )))
    }
}
