//
//  AddEventView.swift
//  Gatherly
//
//  Created by Devon Arnone on 2/16/26.
//

import SwiftUI

struct AddEventView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var vm: AddEventViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Upload Cover Photo")
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
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Event Title")
                        .font(.headline)
                        .foregroundColor(.white)
                    TextField("", text: $vm.title)
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
                    TextField("", text: $vm.location)
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
                    DatePicker("", selection: $vm.timestamp, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .colorScheme(.dark)
                        .tint(.cyan)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Event Description")
                        .font(.headline)
                        .foregroundColor(.white)
                    TextField("", text: $vm.description, axis: .vertical)
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
                    Text("Create Event")
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
        .navigationTitle("Create Event")
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
        AddEventView(vm: AddEventViewModel())
    }
}
