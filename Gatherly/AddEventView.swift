//
//  AddEventView.swift
//  Gatherly
//
//  Created by Devon Arnone on 2/16/26.
//

import SwiftUI
import PhotosUI

struct AddEventView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var vm: AddEventViewModel

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Upload Cover Photo")
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
                        await vm.createEvent()
                    }
                }) {
                    Text("Create Event")
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
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)

            if vm.isSubmitting {
                Color.black.opacity(0.15)
                    .ignoresSafeArea()
                ProgressView("Saving event...")
            }
        }
        .navigationTitle("Create Event")
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
        .onChange(of: vm.didCreateEvent) { _, didCreateEvent in
            if didCreateEvent {
                dismiss()
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddEventView(vm: AddEventViewModel())
    }
}
